<!--- Obtiene el path de Padres --->
<cfset abpath = ListToArray(bpath)>
<cfset path = "">
<cfloop from="#Arraylen(abpath)#" to="1" step="-1" index="i">
	<cfset path = path & iif(len(trim(path)),DE(','),DE('')) & abpath[i]>
</cfloop>
<cfset path = path & iif(len(trim(path)),DE(','),DE('')) & form.IRcodigo>
<cfset LIRcodigo = form.IRcodigo>
<cfloop condition="1 eq 1">
	<cfquery name="rsfrImpuestoRenta" datasource="sifcontrol">
		select IRcodigoPadre 
		from ImpuestoRenta
		where IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LIRcodigo#">
	</cfquery>
	<cfif rsfrImpuestoRenta.recordcount and len(trim(rsfrImpuestoRenta.IRcodigoPadre))>
		<cfset LIRcodigo = rsfrImpuestoRenta.IRcodigoPadre>
		<cfset path = path & "," & rsfrImpuestoRenta.IRcodigoPadre>
	<cfelse>
		<cfbreak>
	</cfif>
</cfloop>
<!--- Pinto el Path ---->
<cfoutput>
<cfif isdefined("path") and Len(Trim(path))>
	<cfset centros = ListToArray(path)>
	<table cellpadding="0" cellspacing="0">
	<tr>
		<td nowrap colspan="#ArrayLen(centros)+1#" align="center" style="border-bottom: 1px solid black; "><strong>Jerarqu&iacute;a</strong></td>
	</tr>
	<cfloop from="#ArrayLen(centros)#" to="1" step="-1" index="i">
		<cfquery name="rsfrIR" datasource="sifcontrol">
			select rtrim(IRcodigo) as centro
			from ImpuestoRenta
			where IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#centros[i]#">
		</cfquery>
		<tr>
			<td colspan="#ArrayLen(centros)-i+1#" align="right">
				<img src="/cfmx/rh/js/xtree/images/L.png" border="0">
			</td>
			<td colspan="#i#">
				<cfif trim(rsfrIR.centro) EQ trim(form.IRcodigo)>
				<strong>#rsfrIR.centro#</strong>
				<cfelse>
				#rsfrIR.centro#
				</cfif>
			</td>
		</tr>
	</cfloop>
	<tr>
	<cfloop from="#ArrayLen(centros)#" to="1" step="-1" index="i">
		<td>&nbsp;</td>
	</cfloop>
	</tr>
	</table>
</cfif>
</cfoutput>