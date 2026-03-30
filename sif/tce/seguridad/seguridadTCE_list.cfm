<cfif isdefined("url.usuario")>
	<cfset form.us=#url.usuario#>
</cfif>
<cfif isdefined("url.modo")>
	<cfset form.modo=#url.modo#>
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<form name="formList" method="post" action="seguridadTCE.cfm">
	<cf_dbfunction name="to_char" args="tce.Usucodigo" returnVariable="LvarUsucodigo">
	
	<!---<cfset LvarImgChecked	= "'<img border=""0"" src=""/cfmx/sif/imagenes/borrar01_S.gif"" style=""cursor:pointer;"" onClick=""sbBajaUsuario('#LvarCNCT# #LvarUsucodigo# #LvarCNCT#');"">'">--->
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		
		tabla=	"
					CBUsuariosTCE tce
					inner join Usuario u
						on u.Usucodigo = tce.Usucodigo
					inner join DatosPersonales dp
						on dp.datos_personales = u.datos_personales	
				"
		
		columnas="	u.Usucodigo,
					tce.CBUid as us
					, u.Usulogin
					, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usuario
				"
				
		filtro="1 = 1 order by u.Usulogin"
		desplegar="Usulogin, Usuario"
		etiquetas="Usuario, Nombre"
		formatos="V,S"
		align="left,left,left"
		ira="seguridadTCE.cfm"
		form_method="post"
		keys="Usucodigo,us"
		showLink="yes"
		incluyeForm="false"
		formName="formList"
        PageIndex ="1"
        MaxRows="13"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		filtrar_Por="Usulogin, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2"
	>
    </cfinvoke>
    
</form>



