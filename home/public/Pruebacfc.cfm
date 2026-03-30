<cfinvoke component="sif.Componentes.sp_FDocumentosCC" 
method="FDocumentosCC" 
returnvariable="rs"
Conexion = "#session.DSN#"
Dreferencia= '173'
Idioma='0'
firmaAutorizada = 'Danny'
CCtipo = 'D'
>

<cfdump var="#rs#">