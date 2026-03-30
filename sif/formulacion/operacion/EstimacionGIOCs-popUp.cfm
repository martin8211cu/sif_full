<cfif not isdefined('form.FPDEid') and isdefined('url.FPDEid')>
	<cfset form.FPDEid = url.FPDEid>
</cfif>

<cfquery name="rsOrdenCM" datasource="#session.DSN#">
	select distinct b.EOidorden, c.EOnumero, SNnombre, Observaciones
	from FPDEstimacion a
		inner join DOrdenCM b
			on b.PCGDid = a.PCGDid and b.Ecodigo = a.Ecodigo
		inner join EOrdenCM c
			on c.EOidorden = b.EOidorden
		inner join SNegocios d
			on d.SNcodigo = c.SNcodigo and d.Ecodigo = c.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	 and a.FPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPDEid#">
</cfquery>
<cfif rsOrdenCM.recordcount eq 1>
	<cflocation url="../../cm/consultas/OrdenesCompra-vista.cfm?EOidorden=#rsOrdenCM.EOidorden#" addtoken="no">
<cfelse>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Ordenes de Compra Ligadas a la Plan de Compras">
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query		="#rsOrdenCM#"
			desplegar	="EOnumero, SNnombre, Observaciones"
			etiquetas	="Numero Orden, Socio, Descripción"
			formatos	="I,S,S"
			align		="left, left, left"
			ira			="../../cm/consultas/OrdenesCompra-vista.cfm?EOidorden=#rsOrdenCM.EOidorden#"
			form_method	="post"
			keys		="EOidorden"	
			MaxRows		="5"
			usaAJAX 	= "true"
			conexion 	= "#session.DSN#"	
			formName	="OC_#form.FPDEid#"
			Botones		="Cerrar"
		/>
		<script language="javascript1.2" type="text/javascript">
			function funcCerrar(){
				window.close();
				return true;
			}
		</script>
	<cf_web_portlet_end>
</cfif>