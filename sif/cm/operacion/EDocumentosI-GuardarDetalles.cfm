<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset vnAccion = "commit">
<cftransaction>
	<cfloop list="#form.Lineas#" index="i">
		<!----Actualizacion de cantidades----->
		<cfif isdefined("form.DDIcantidad_#i#") and len(trim(form["DDIcantidad_#i#"]))>
			<cfquery datasource="#session.DSN#">
				update DDocumentosI
				set DDIcantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form['DDIcantidad_#i#'],',','','all')#">,
					cantidadrestante = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form['DDIcantidad_#i#'],',','','all')#">
				where DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
			</cfquery>
		</cfif>
		<!----Actualizacion de precios------>
		<cfif isdefined("form.DDIpreciou_#i#") and len(trim(form["DDIpreciou_#i#"]))>
			<cfquery datasource="#session.DSN#">
				update DDocumentosI 
				set DDIpreciou = #LvarOBJ_PrecioU.enCF(replace(form['DDIpreciou_#i#'],',','','all'))#
				where DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
			</cfquery>
		</cfif>
		<!---Calculo del porcentaje de descuento----->
		<cfif isdefined("form.Mtodesc_#i#") and len(trim(form["Mtodesc_#i#"])) and isdefined("form.DDItotallineaCD_#i#") and len(trim(form["DDItotallineaCD_#i#"]))>
			<cfset porcDesc = 0>
			<cfset montoDesc = replace(form['Mtodesc_#i#'],',','','all')>
			<cfset totLinea = replace(form['DDItotallineaCD_#i#'],',','','all')>			
			
			<cfoutput>
				<cfif totLinea + montoDesc EQ 0>
					<cfset porcDesc = 0 >
				<cfelse>
					<cfset porcDesc = (montoDesc * 100) / (totLinea + montoDesc)>
				</cfif>
			</cfoutput>
			
			<cfquery datasource="#session.DSN#">
				update DDocumentosI 
				set DDIporcdesc = <cfqueryparam cfsqltype="cf_sql_float" value="#porcDesc#">
				where DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
			</cfquery>
		</cfif>
		<!----Actualiza totales---->
		<cfif isdefined("form.DDItotallineaCD_#i#") and len(trim(form["DDItotallineaCD_#i#"]))>
			<!---Verificar si algún registro tiene el total en cero---->
			<cfif form["DDItotallineaCD_#i#"] EQ 0>
				<cfset vnAccion = "rollback">
			</cfif>
			<cfquery datasource="#session.DSN#">
				update DDocumentosI
				set DDItotallinea = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form['DDItotallineaCD_#i#'],',','','all')#">,
					montorestante = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form['DDItotallineaCD_#i#'],',','','all')#">
				where DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
			</cfquery>
		</cfif>			
	</cfloop>
	<cfif vnAccion EQ 'rollback'>
		<script type="text/javascript" language="javascript1.2">
			alert("Los totales de las líneas no pueden ser cero");
		</script>
	</cfif>	
	<cftransaction action="#vnAccion#">
</cftransaction>
<form action="EDocumentosI.cfm" method="post" name="sql">
	<cfoutput>
		<input name="EDIid" type="hidden" value="<cfif isdefined("form.EDIid") and len(trim(form.EDIid))>#form.EDIid#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
		<cfif isdefined("form.EPDid_DP") and len(trim(form.EPDid_DP))>
			<input type="hidden" name="EPDid_DP" value="#form.EPDid_DP#">
		</cfif>
	</cfoutput>
</form>

<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>