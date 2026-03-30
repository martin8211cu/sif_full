<cf_templateheader title="Empresas">

<cf_web_portlet_start titulo="Empresas">

<cfinvoke component="home.Componentes.Politicas" method="trae_parametro_global"
	parametro="sesion.duracion.default" returnvariable="duracion_default"/>
<cfinvoke component="home.Componentes.Politicas" method="trae_parametro_global"
	parametro="sesion.duracion.modo" returnvariable="duracion_modo"/>
	
<cfset aspmonitor = Application.dsinfo.aspmonitor.schema>

<cfquery datasource="asp" name="cachesok">
	select Cid
	from Caches
	where Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
</cfquery>

<cfset SubqueryEmpleados = 
	"(select count(1) from UsuarioReferencia ur " & 
	" where ur.Ecodigo = e.Ecodigo " & 
	" and ur.STabla = 'DatosEmpleado' " & 
	" ) " >

<cfset SubquerySesiones = 
	"(select count(1) from #aspmonitor#..MonProcesos mp" & 
	" where mp.Ecodigo = e.Ecodigo" & 
	" and mp.CEcodigo = e.CEcodigo" & 
	" and mp.cerrada = 0" & 
	" and mp." & IIf( duracion_modo is '1', DE('desde'), DE('acceso') ) &
	" >= " & DateAdd('n', -duracion_default, Now()) &
	" )" >

<cfset SubqueryActiva = "(case when Eactiva = 1 then 'Activa' else 'Inactiva' end +
	case when EactivaMotivo is null then null else ' (' + EactivaMotivo + ')' end)">

<cfset SubqueryRespaldos = 
	"(select max(REfecha) from RespaldoEmpresa re " & 
	" where re.CEcodigo = e.CEcodigo" & 
	" and re.Ecodigo = e.Ecodigo" & 
	" ) " >

<cfset CodigoChar = "' + convert(varchar(30),CEcodigo) + ',' + convert(varchar(30),Ecodigo) + '">

<cffunction name="sql_icono2">
	<cfargument name="title" type="string" required="yes">
	<cfargument name="func" type="string" required="yes">
	<cfargument name="grayedout" type="boolean" required="yes">
	<cfset var ret = 
		'<a href="javascript:#func#(#codigoChar#,#IIF(grayedout,1,0)#)">' &
		'<img src="#Lcase(func)#' &
		IIF(grayedout, DE('-gray'), DE('')) &
		'.gif" alt="#title#" title="#title#" ' &
		'border="0" width="45" height="18">' &
		'</a>'>
	<cfreturn '''' & ret & ''''>
</cffunction>

<cffunction name="sql_icono">
	<cfargument name="title" type="string" required="yes">
	<cfargument name="func" type="string" required="yes">
	<cfargument name="grayedout" type="boolean" required="yes">
	<cfset var ret =
		' case when e.Cid in (' & ValueList(cachesok.Cid) & ') then ' &
			sql_icono2(title,func,false) &
		' else ' &
			sql_icono2(title,func,grayedout) &
		' end '>
	<cfreturn ret>
</cffunction>

<cfset iPerm = sql_icono('Permisos','iPerm',false)>
<cfset iDump = sql_icono('Respaldar','iDump',true)>
<cfset iLoad = sql_icono('Cargar respaldo','iLoad',true)>
<cfset iEnable = sql_icono('Habilitar/Inhabilitar','iEnable',false)>
<cfset iInd = sql_icono('Indicadores','iInd',false)>

<cfif IsDefined('session.statusmsg') And Len(session.statusmsg)>
<div style="padding:3px;text-align:center;cursor:pointer;" onclick="this.style.display='none';"><span style="background-color:black;color:white;font-weight:bold;text-align:center;padding:3px;margin:3px;spacing:3px">
<cfoutput>&nbsp;&nbsp;&nbsp;Mensaje: #HTMLEditFormat(session.statusmsg)#&nbsp;&nbsp;&nbsp;</cfoutput>
<cfset session.statusmsg = ''>
</span></div></cfif>

<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="Empresa e"
	columnas="CEcodigo,Ecodigo,Enombre,#SubqueryActiva# as estado, 
		#SubquerySesiones# as sesiones, #SubqueryEmpleados# as empleados, #SubqueryRespaldos# as ultRespaldo,  
		#iperm# as iPermiso, #idump# as iRespaldo, #iload# as iLoad, #ienable# as iEnable, #iind# as iInd"
	desplegar="Enombre,estado,sesiones,empleados,iPermiso,iRespaldo,iLoad,iEnable,iInd,ultRespaldo"
	etiquetas="Nombre,Estado,Sesiones,Empleados, , , , , ,&Uacute;ltimo respaldo"
	formatos="S,S,I,I,S,S,S,S,S,DT"
	filtro="e.CEcodigo != 1 and exists( select 1 from ModulosCuentaE x where x.SScodigo = 'aspweb' and x.CEcodigo = e.CEcodigo ) order by Enombre"
	align="left, left,right,right,left,left,left,left,left,left"
	ajustar="N"
	funcion="ver_empresa"
	fparams="CEcodigo,Ecodigo"
	maxRows="20"
	keys="Ecodigo"
	cortes=""
	conexion="asp"
	navegacion=""
	showEmptyListMsg="true"
	mostrar_filtro="yes"
	filtrar_automatico="yes"
	filtrar_por="Enombre;#SubqueryActiva#;#SubquerySesiones#;#SubqueryEmpleados#;' ';' ';' ';' ';' ';#SubqueryRespaldos#"
	filtrar_por_delimiters=";"
	botones="Crear_Nueva_Empresa,Opciones" />

<script type="text/javascript">
function funcCrear_Nueva_Empresa(){
	window.open('crear/index.cfm', '_self');
	return false;
}
function funcOpciones(){
	window.open('opciones/opciones.cfm', '_self');
	return false;
}
function iPerm(ce,e){
	window.open('permiso/simple.cfm?ce=' + escape(ce) + '&e=' + escape(e), '_self');
	return false;
}
function iDump(ce,e,grayedout){
	if(grayedout) {
		alert('La opción de respaldo no está disponible para esta empresa');
		return;
	}
	window.open('respaldo/params.cfm?accion=respaldar&ctae=' + escape(ce) + '&emp=' + escape(e), '_self');
}
function iLoad(ce,e,grayedout){
	if(grayedout) {
		alert('La opción de carga de respaldo no está disponible para esta empresa');
		return;
	}
	window.open('respaldo/params.cfm?accion=cargar&ctae=' + escape(ce) + '&emp=' + escape(e), '_self');
}
function iEnable(ce,e){
	window.open('habilitar/habilitar.cfm?ctae=' + escape(ce) + '&emp=' + escape(e), '_self');
	return false;
}
function iInd(ce,e){
	window.open('detalle.cfm?ctae=' + escape(ce) + '&emp=' + escape(e), '_self');
	return false;
}
function ver_empresa(ce,e){
	window.open('crear/index.cfm?ctae=' + escape(ce) + '&emp=' + escape(e), '_self');
	return false;
}
</script>

<cf_web_portlet_end>

<cf_templatefooter>