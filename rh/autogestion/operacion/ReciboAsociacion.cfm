<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ResumenMensual" default="Resumen Mensual" returnvariable="LB_ResumenMensual" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#Session.Preferences.Skin#">
	  	<cfinclude template="/rh/Utiles/params.cfm">
		
		<cfquery name="rsDEid" datasource="#session.dsn#">
		   select llave from UsuarioReferencia where Usucodigo = #session.usucodigo# and STabla = 'DatosEmpleado' 
		</cfquery>
		<cfif rsDEid.recordcount gt 0 and  len(trim(#rsDEid.llave#))>
		 <cfset LvarDEid = #rsDEid.llave#>
		</cfif>
		
		<cfquery name="DatosPago" datasource="#session.dsn#">
		 Select CPid, a.Ecodigo, a.Tcodigo <!--- RCdesde, RChasta--->
			from HRCalculoNomina a   <!---Relacion Calculo--->
				inner join HSalarioEmpleado b <!---Quienes esran en la Relacion--->
				on a.RCNid=b.RCNid
				inner join CalendarioPagos c   <!---Calendarios asocados al Historico--->
				on a.RCNid=c.CPid
				and c.CPtipo=0   <!---Pagos Ordinario--->
			Where b.DEid=#LvarDEid#
			and RCdesde in (Select Max(RCdesde) 
							from HRCalculoNomina d
							inner join HSalarioEmpleado e
								on d.RCNid=e.RCNid
							inner join CalendarioPagos f
								on d.RCNid=f.CPid
							and f.CPtipo=0  <!---Pagos Ordinarios--->
							Where e.DEid=b.DEid)
			order by RCdesde desc       
		</cfquery>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" colspan="2">
					<cfset params = ''>
					<cfif isdefined('DatosPago.Tcodigo') and LEN(TRIM(DatosPago.Tcodigo))>
						<cfset params = params & '&Tcodigo=' & DatosPago.Tcodigo>
					</cfif>
					<cfif isdefined('DatosPago.CPid') and LEN(TRIM(DatosPago.CPid))>
						<cfset params = params & '&CPid=' & DatosPago.CPid>
					</cfif>
                    <cfif isdefined('LvarDEid') and LEN(TRIM(LvarDEid))>
						<cfset params = params & '&DEid=' & LvarDEid>						
					</cfif>					
					<cf_reportWFormat url="/rh/asoc/consultas/ReciboAportes-rep.cfm" orientacion="portrait" params="#params#" pagina="true">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>