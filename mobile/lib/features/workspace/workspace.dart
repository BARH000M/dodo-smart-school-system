import 'package:flutter/material.dart';
import '../../core/backend.dart';
import '../records/module_page.dart';
class Workspace extends StatefulWidget {
  const Workspace({super.key,required this.ar,required this.specs,required this.toggle});
  final bool ar; final List<RowData> specs; final VoidCallback toggle;
  @override State<Workspace> createState() => _WorkspaceState();
}
class _WorkspaceState extends State<Workspace> {
  List<RowData> members=[], schools=[]; String? school; String error=''; String search=''; bool busy=true;
  @override void initState(){super.initState();load();}
  Future<void> load() async {
    setState((){busy=true;error='';});
    try {final m=asRows(await db.from('school_memberships').select('school_id,role').eq('active',true)); final s=asRows(await db.from('schools').select('id,name,currency'));if(mounted)setState((){members=m;schools=s;school=s.isEmpty?null:s.first['id'] as String;});}
    catch(e){if(mounted)setState(()=>error=e.toString());}finally{if(mounted)setState(()=>busy=false);}
  }
  @override Widget build(BuildContext context){final ar=widget.ar;final roles=members.where((m)=>m['school_id']==school).map((m)=>m['role']).toSet();final allowed=widget.specs.where((m)=>(m['read'] as List).any(roles.contains) && ('${m['ar']} ${m['en']}').toLowerCase().contains(search.toLowerCase())).toList();return Scaffold(appBar: AppBar(title:const Text('DODO'),actions:[TextButton(onPressed:widget.toggle,child:Text(ar?'English':'العربية')),IconButton(tooltip:tr(ar,'خروج','Sign out'),onPressed:() async {try{await db.auth.signOut();}catch(e){if(mounted)setState(()=>error=e.toString());}},icon:const Icon(Icons.logout))]),body:RefreshIndicator(onRefresh:load,child:ListView(padding:const EdgeInsets.all(16),children:[
    Text(tr(ar,'لوحة التحكم','Dashboard'),style:Theme.of(context).textTheme.headlineSmall),const SizedBox(height:12),if(busy) const LinearProgressIndicator(),if(error.isNotEmpty) Text(error),
    if(school!=null) DropdownButtonFormField<String>(key:ValueKey(school),initialValue:school,decoration:InputDecoration(labelText:tr(ar,'المدرسة','School')),items:schools.map((s)=>DropdownMenuItem(value:s['id'] as String,child:Text(s['name'].toString()))).toList(),onChanged:(v)=>setState(()=>school=v)),
    if(!busy&&school==null) Text(tr(ar,'لا توجد عضوية مدرسة مفعلة','No active school membership')),
    if(!busy&&school!=null&&allowed.isEmpty) Text(tr(ar,'لا توجد وحدات متاحة لدورك في الإصدار الأولي','No pilot modules available for your role yet')),
    TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search),hintText:tr(ar,'بحث الوحدات','Search modules')),onChanged:(v)=>setState(()=>search=v)),
    ...allowed.map((m)=>Card(child:ListTile(leading:const Icon(Icons.folder_open),title:Text(label(m,ar)),trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>ModulePage(spec:m,school:school!,ar:ar,canWrite:(m['write'] as List).any(roles.contains))))))),
  ])));}
}
