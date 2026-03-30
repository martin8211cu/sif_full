<!--- ** Creado por Jose Gutierrez ---febrero 2018---***********
***********************************************************************************************--->


<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>


<cfset vFiltro = "">
<cfif isdefined('cgi.HTTP_REFERER')>
	<cfif findNoCase('MenuCC',cgi.HTTP_REFERER,1)>
		<cfset session.LvarModulo = 'CC'>
	<cfelseif findNoCase('MenuCP',cgi.HTTP_REFERER,1)>
		<cfset session.LvarModulo = 'CP'>
	<cfelseif findNoCase('MenuAD',cgi.HTTP_REFERER,1)>
		<cfset session.LvarModulo = 'AD'>
	</cfif>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReAplicacionPagos" Default="Re aplicaci&oacute;n de pagos" XmlFile="/sif/generales.xml" returnvariable="LB_ReAplicacionPagos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Numero" Default= "N&uacute;mero" XmlFile="listaSocios.xml" returnvariable="LB_Numero"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default= "Nombre" XmlFile="listaSocios.xml" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default= "Identificaci&oacute;n" XmlFile="listaSocios.xml" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo" Default= "Tipo" XmlFile="listaSocios.xml" returnvariable="LB_Tipo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Usuario" Default= "Usuario" XmlFile="listaSocios.xml" returnvariable="LB_Usuario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Dist" default = "Distribuidor" returnvariable="LB_Dist" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SociosNegocio" Default= "Re aplicaci&oacute;n de pagos" XmlFile="listaSocios.xml" returnvariable="LB_SociosNegocio"/>

<cf_templateheader title="#LB_ReAplicacionPagos#">
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="<cfoutput>#LB_SociosNegocio#</cfoutput>">

			<!--- Declaración de Variables --->
			<cf_dbfunction name="to_char" args="SNid" returnvariable="SNid_char">
			<cf_dbfunction name="concat" returnvariable="redalert"    args="<img border=''0'' src=''/cfmx/sif/imagenes/stop.gif''  title=''Faltan Clasificaciones Requeridas'' onClick=javascript:doConlisAlertas('''+#SNid_char#+''')>" delimiters="+">
			<cf_dbfunction name="concat" returnvariable="yellowalert" args="<img border=''0'' src=''/cfmx/sif/imagenes/stop4.gif'' title=''Faltan Clasificaciones Requeridas'' onClick=javascript:doConlisAlertas('''+#SNid_char#+''')>" delimiters="+">

			<cfset checked    = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
			<cfset unchecked  = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >

			<cfquery name="rsConsultaCorp" datasource="asp">
				select 1
				from CuentaEmpresarial
				where Ecorporativa is not null
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
			</cfquery>
			<cfif isdefined('session.Ecodigo') and
				  isdefined('session.Ecodigocorp') and
				  session.Ecodigo NEQ session.Ecodigocorp and
				  rsConsultaCorp.RecordCount GT 0>
				  <cfset filtro = " and b.Ecodigo=#session.Ecodigo#">
			<cfelse>
				  <cfset filtro = " and b.Ecodigo is null">
			</cfif>
			<cfquery name="rsN" datasource="#session.dsn#">
				select coalesce(sum(1),0) as N
				from SNClasificacionE b
				where b.CEcodigo=#session.CEcodigo# #filtro#
				and b.PCCEobligatorio = 1
				and b.PCCEactivo = 1
			</cfquery>
			<cfif rsN.recordcount>
				<cfset Lvar_ClasificacionesObligatorias = rsN.N>
			<cfelse>
				<cfset Lvar_ClasificacionesObligatorias = 0>
			</cfif>
			<cfquery name="rsM" datasource="#session.dsn#">
				select coalesce(sum(1),0) as M
				from SNClasificacionE b
				where b.CEcodigo=#session.CEcodigo# #filtro#
				and b.SNCEalertar= 1
				and b.PCCEactivo = 1
			</cfquery>
			<cfif rsM.recordcount>
				<cfset Lvar_ClasificacionesAAlertar = rsM.M>
			<cfelse>
				<cfset Lvar_ClasificacionesAAlertar = 0>
			</cfif>

			<cfquery name="rsalerta" datasource="#session.DSN#">
				select count(1) as alerta
				from SNClasificacionE b
				where b.PCCEobligatorio = 1
				  and b.PCCEactivo = 1
				  and (b.CEcodigo=#session.CEcodigo# #filtro#)
			</cfquery>
			<cfset LvarAlerta1 = rsalerta.alerta>

			<cfquery name="rsAlerta" datasource="#session.DSN#">
				select count(1) as alerta
				from SNClasificacionE b
				where b.PCCEobligatorio = 1
				  and b.PCCEactivo = 1
				  and (b.CEcodigo=#session.CEcodigo# #filtro#)
				  and b.SNCtiposocio in ('A', 'P')
			</cfquery>
			<cfset LvarAlerta2 = rsalerta.alerta>

			<cfquery name="rsAlerta" datasource="#session.DSN#">
				select count(1) as alerta
				from SNClasificacionE b
				where b.PCCEobligatorio = 1
				  and b.PCCEactivo = 1
				  and (b.CEcodigo=#session.CEcodigo# #filtro#)
				  and b.SNCtiposocio in ('A', 'C')
			</cfquery>
			<cfset LvarAlerta3 = rsalerta.alerta>

			<cfquery name="rsAlerta" datasource="#session.DSN#">
				select count(1) as alerta
				from SNClasificacionE b
				where b.SNCEalertar =1
				  and b.PCCEactivo = 1
				  and (b.CEcodigo=#session.CEcodigo# #filtro#)
			</cfquery>
			<cfset LvarAlerta4 = rsalerta.alerta>

			<cfquery name="rsAlerta" datasource="#session.DSN#">
				select count(1) as alerta
				from SNClasificacionE b
				where b.SNCEalertar =1
				  and b.PCCEactivo = 1
				  and (b.CEcodigo=#session.CEcodigo# #filtro#)
				  and b.SNCtiposocio in ('A', 'P')
			</cfquery>
			<cfset LvarAlerta5 = rsalerta.alerta>

			<cfquery name="rsAlerta" datasource="#session.DSN#">
				select count(1) as alerta
				from SNClasificacionE b
				where b.SNCEalertar =1
				  and b.PCCEactivo = 1
				  and (b.CEcodigo=#session.CEcodigo# #filtro#)
				  and b.SNCtiposocio in ('A', 'C')
			</cfquery>
			<cfset LvarAlerta6 = rsalerta.alerta>

<cfif isdefined('session.LvarModulo') and session.LvarModulo EQ 'CC'>
	<cfset vFiltro = "and (sn.SNtiposocio = 'C' or sn.SNtiposocio = 'A')">
<cfelseif isdefined('session.LvarModulo') and session.LvarModulo EQ 'CP'>
	<cfset vFiltro = "and (sn.SNtiposocio = 'P' or sn.SNtiposocio = 'A')">
</cfif>
<cfset Filtro2 = " and (disT = 1)">
			<cfinvoke
				component="sif.Componentes.pListas"
				method="pLista">
				<cfinvokeargument name="columnas" value="SNcodigo, SNtiposocio, SNnumero, SNnombre, SNidentificacion,
				case
					when disT is NULL then '#unchecked#'
					when disT = 0 then '#unchecked#'
					else '#checked#'
				end as disT,LOCidioma "/>
				<cfinvokeargument name="tabla" value="SNegocios sn"/>
				<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# #vFiltro# #Filtro2#  order by SNnumero, SNnombre
				"/>
				<cfinvokeargument name="desplegar" value="SNnumero, SNnombre, SNidentificacion "/>
				<cfinvokeargument name="etiquetas" value="#LB_Numero#, #LB_Nombre#, #LB_Identificacion#"/>
				<cfinvokeargument name="formatos" value="S, S, S"/>
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="irA" value="ReAplicacionPagos_form.cfm"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="ajustar" value="S"/> 
				<cfinvokeargument name="keys" value="SNcodigo"/>
			</cfinvoke>
			<script type="text/javascript">
				<!--
					var popUpWinAlertas=null;
					function popUpWindowAlertas(URLStr, left, top, width, height)
					{
					  if(popUpWinAlertas)
					  {
						if(!popUpWinAlertas.closed) popUpWinAlertas.close();
					  }
					  popUpWinAlertas = open(URLStr, 'popUpWinAlertas', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
					  if (! popUpWinAlertas && !document.popupblockerwarning) {
						alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
						document.popupblockerwarning = 1;
					  }
					}
					function doConlisAlertas(SNid){
						if ((SNid)&&(SNid>0)) {
							popUpWindowAlertas('listaSocios-PopupAlerta.cfm?SNid='+SNid,150,150,600,400);
						}
						document.lista.nosubmit=true;
						return false;
					}
					function funcImportar(){
						window.open('SociosImportar.cfm','_self');
						return false;
					}
					function funcImportador(){
						window.open('SociosImportador.cfm','_self');
						return false;
					}
					function nuevoSocio(){
						document.filtro.action = "Socios.cfm";
					}
					function funcImportar_Cuentas_Excepcion()
					{
						document.location.href ="../../Importar/CargaCuentasExp-form.cfm";
						return false;
					}
				//-->
			</script>
		<cf_web_portlet_end>
<cf_templatefooter>