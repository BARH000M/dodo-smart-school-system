export type Field={name:string;ar:string;en:string;kind:string;optional?:boolean;table?:string;label?:string;options?:string[]};
export type Module={table:string;ar:string;en:string;group?:string;read:string[];write:string[];fields:Field[];display:string[];rpc?:string};
export type Data=Record<string,any>;
