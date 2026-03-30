<!--- ** Modificado por Dorian Abarca Gómez/Fecha: 21-03-2006/Motivo: Se modifica un poco el pintado para aprovechar las ********
******* características de los genéricos de listas y otros, y se agrega indicador de alertas y requerido de clasificaciones. ***********
******* Modificado por Gustavo Fonseca H/Fecha: 12-12-2005/Motivo: Se agrega el SNidentificación como columna en el listado*****
******* y como filtro. También se encontró que la lista no estaba utilizando la navegación porque perdía los valores del filtro,*******
******* eso se corrigió. ****************************************************************************************--->

<cfinclude template="SociosModalidad.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<cfif isdefined('cgi.HTTP_REFERER')>
	<cfif findNoCase('MenuCC',cgi.HTTP_REFERER,1)>
		<cfset session.LvarModulo = 'CC'>
	<cfelseif findNoCase('MenuCP',cgi.HTTP_REFERER,1)>
		<cfset session.LvarModulo = 'CP'>
	<cfelseif findNoCase('MenuAD',cgi.HTTP_REFERER,1)>
		<cfset session.LvarModulo = 'AD'>
	</cfif>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SIFAdministracionDelSistema"
	Default="SIF - Administraci&oacute;n del Sistema"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			
			<!--- Declaración de Variables --->
			<cf_dbfunction name="to_char" args="SNid" returnvariable="SNid_char">
			<cf_dbfunction name="concat" returnvariable="redalert"    args="<img border=''0'' src=''/cfmx/sif/imagenes/stop.gif''  title=''Faltan Clasificaciones Requeridas'' onClick=javascript:doConlisAlertas('''+#SNid_char#+''')>" delimiters="+">
			<cf_dbfunction name="concat" returnvariable="yellowalert" args="<img border=''0'' src=''/cfmx/sif/imagenes/stop4.gif'' title=''Faltan Clasificaciones Requeridas'' onClick=javascript:doConlisAlertas('''+#SNid_char#+''')>" delimiters="+">
			
			<cfset checked    = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
			<cfset unchecked  = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
			<cfset greenalert = "<img border=0 src=/cfmx/sif/imagenes/stop2.gif>" >		
			
			<!--- 
			<cfset redalert    = " {fn concat( {fn concat( '<a href='''' onclick = ''doConlisAlertas(' , #SNid_char# )}, ')''><img title=''Faltan Clasificaciones Requeridas'' border=''0'' src=''/cfmx/sif/imagenes/stop.gif''></a>' )} " >
			<cfset yellowalert = " {fn concat( {fn concat( '<a href='''' onclick = ''doConlisAlertas(' , #SNid_char# )}, ')''><img title=''Faltan Clasificaciones con Alertas'' border=''0'' src=''/cfmx/sif/imagenes/stop4.gif''></a>'  )}" > 
			--->
	
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


				case when (
					case 
						when sn.SNtiposocio = 'A' then
							#LvarAlerta1#
						when sn.SNtiposocio = 'P' then
							#LvarAlerta2#
						when sn.SNtiposocio = 'C' then
							#LvarAlerta3#
					end
					-
					case 
						when sn.SNtiposocio = 'A' then
							(( 
								select count(1)
								from SNClasificacionSN cs
									inner join SNClasificacionD d
										inner join SNClasificacionE b
										on b.SNCEid = d.SNCEid
										  and b.PCCEactivo = 1
										  and b.PCCEobligatorio = 1
										  and (b.CEcodigo=#session.CEcodigo# #filtro#)
									on d.SNCDid = cs.SNCDid
								where cs.SNid = sn.SNid
							)) 
				
						when sn.SNtiposocio = 'P' then
							(( 
								select count(1)
								from SNClasificacionSN cs
									inner join SNClasificacionD d
										inner join SNClasificacionE b
										on b.SNCEid = d.SNCEid
										  and b.PCCEactivo = 1
										  and b.PCCEobligatorio = 1
										  and (b.CEcodigo=#session.CEcodigo# #filtro#)
										  and b.SNCtiposocio in ('A', 'P')
									on d.SNCDid = cs.SNCDid
								where cs.SNid = sn.SNid
				
							)) 
				
						when sn.SNtiposocio = 'C' then
							(( 
								select count(1)
								from SNClasificacionSN cs
									inner join SNClasificacionD d
										inner join SNClasificacionE b
										on b.SNCEid = d.SNCEid
										  and b.PCCEactivo = 1
										  and b.PCCEobligatorio = 1
										  and (b.CEcodigo=#session.CEcodigo# #filtro#)
										  and b.SNCtiposocio in ('A', 'C')
									on d.SNCDid = cs.SNCDid
								where cs.SNid = sn.SNid
							)) 
					end
				) > 0 then '#redalert#' else '' end as requeridos,

				case when (
					case 
							when sn.SNtiposocio = 'A' then
								#LvarAlerta4#
							when sn.SNtiposocio = 'P' then
								#LvarAlerta5#
							when sn.SNtiposocio = 'C' then
								#LvarAlerta6#
						end
						-
						case 
							when sn.SNtiposocio = 'A' then
								(( 
									select count(1)
									from SNClasificacionSN cs
										inner join SNClasificacionD d
											inner join SNClasificacionE b
											on b.SNCEid = d.SNCEid
											  and b.PCCEactivo = 1
											  and b.SNCEalertar =1
											  and (b.CEcodigo=#session.CEcodigo# #filtro#)
										on d.SNCDid = cs.SNCDid
									where cs.SNid = sn.SNid
								)) 
					
							when sn.SNtiposocio = 'P' then
								(( 
									select count(1)
									from SNClasificacionSN cs
										inner join SNClasificacionD d
											inner join SNClasificacionE b
											on b.SNCEid = d.SNCEid
											  and b.PCCEactivo = 1
											  and b.SNCEalertar =1
											  and (b.CEcodigo=#session.CEcodigo# #filtro#)
											  and b.SNCtiposocio in ('A', 'P')
										on d.SNCDid = cs.SNCDid
									where cs.SNid = sn.SNid
					
								)) 
					
							when sn.SNtiposocio = 'C' then
								(( 
									select count(1)
									from SNClasificacionSN cs
										inner join SNClasificacionD d
											inner join SNClasificacionE b
											on b.SNCEid = d.SNCEid
											  and b.PCCEactivo = 1
											  and b.SNCEalertar =1
											  and (b.CEcodigo=#session.CEcodigo# #filtro#)
											  and b.SNCtiposocio in ('A', 'C')
										on d.SNCDid = cs.SNCDid
									where cs.SNid = sn.SNid
								)) 
						end
				) > 0 then '#yellowalert#' else '' end as alertas,
			 	'' as esp"/>
				<cfinvokeargument name="tabla" value="SNegocios sn"/>
				<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by SNnumero, SNnombre"/>
				<cfinvokeargument name="desplegar" value="SNnumero, SNnombre, SNidentificacion, SNtiposocio, Usuario, corp, requeridos, alertas, esp"/>
				<cfinvokeargument name="etiquetas" value="N&uacute;mero, Nombre, Identificaci&oacute;n, Tipo, Usuario, Corporativo, Requeridos,  Alertas,  "/>
				<cfinvokeargument name="formatos" value="S, S, S, S, U, U, U, U, U"/>
				<cfinvokeargument name="align" value="left, left, left, left, left, left, center, center, left"/>
				<cfinvokeargument name="irA" value="Socios.cfm"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="ajustar" value="S"/>
				
				<cfif modalidad.importar>
					<cfinvokeargument name="botones" value="Nuevo,Importar, Importar_Cuentas_Excepcion"/>
				<cfelse>
					<cfinvokeargument name="botones" value="Nuevo"/>
				</cfif>
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