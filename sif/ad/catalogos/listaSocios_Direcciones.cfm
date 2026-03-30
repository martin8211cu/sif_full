<!--- <cfinclude template="SociosModalidad.cfm"> --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfset filtroSN = "">
<cfif isdefined('session.proceso.PROCESO_AUTORIZADO00_SMCODIGO') and session.proceso.PROCESO_AUTORIZADO00_SMCODIGO EQ 'CP'>
	<cfset filtroSN = "and SNtiposocio IN ('A','P') ">
<cfelseif isdefined('session.proceso.PROCESO_AUTORIZADO00_SMCODIGO') and session.proceso.PROCESO_AUTORIZADO00_SMCODIGO EQ 'CC'>
	<cfset filtroSN = "and SNtiposocio IN ('A','C') ">
</cfif>
	<cf_templateheader title="#nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfset checked = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
			<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
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
			<form name="form1" method="post" action="SociosDireccion.cfm">
			<cfinvoke 
				component="sif.Componentes.pListas" 
				method="pLista">
				<cfinvokeargument name="columnas" value="SNcodigo, SNtiposocio, SNnumero, SNnombre, SNidentificacion,
					case
						when EUcodigo is NULL then '#unchecked#'
						else '#checked#'
					end as Usuario,
					case 
						when SNidCorporativo is null then '#unchecked#'
						else '#checked#'
					end as corp,
					 '' as esp"/>
				<cfinvokeargument name="tabla" value="SNegocios"/>
				<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# #filtroSN#  order by SNnumero, SNnombre"/>
				<cfinvokeargument name="desplegar" value="SNnumero, SNnombre, SNidentificacion, SNtiposocio, Usuario, corp, esp"/>
				<cfinvokeargument name="etiquetas" value="N&uacute;mero, Nombre, Identificaci&oacute;n, Tipo, Usuario, Corporativo,  "/>
				<cfinvokeargument name="formatos" value="S, S, S, S, U, U, U"/>
				<cfinvokeargument name="align" value="left, left, left, left, left, left, left"/>
				<cfinvokeargument name="irA" value="SociosDireccion.cfm"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="keys" value="SNcodigo"/>
				<cfinvokeargument name="incluyeForm" value="false"/>
				<cfinvokeargument name="formName" value="form1"/>	
				<cfinvokeargument name="pageindex" value="1"/>	
			</cfinvoke> 
			</form>
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
					function funcImportar(){alert('Importara');
						window.open('SociosImportar.cfm','_self');
						return false;
					}
					function nuevoSocio(){
						document.filtro.action = "Socios.cfm";
					}
				//-->
			</script>
<cf_web_portlet_end>
<cf_templatefooter>