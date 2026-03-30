<!--- QUERY PARA MAQUINAS, PARA EL CAMPO DESCRIPCION Y COD--->
<cfif isdefined("Form.FAM09MAQ") and len(trim(Form.FAM09MAQ))>
	<cfquery name="rsFAM09"  datasource="#session.dsn#">
		select FAM09MAQ, FAM09DES
		from FAM009
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
		and FAM09MAQ= <cfqueryparam cfsqltype= "cf_sql_tinyint" value="#Form.FAM09MAQ#">
	</cfquery>
</cfif>
<!--- Pantalla --->
<cfset titulo = "">
<cfset indicacion = "">
<cfif form.Paso EQ 0>
	<cfset titulo = "Consola de Máquinas">
	<cfset indicacion = "Utilice la consola para completar la definición de una máquina">
<cfelseif form.Paso EQ 1>
	<cfset titulo = "Máquinas">
	<cfif isdefined("Form.FAM09MAQ") and len(trim(Form.FAM09MAQ))>
		<cfset indicacion = "#rsFAM09.FAM09MAQ# - #rsFAM09.FAM09DES#"><!---  -  #form.FAM09DES#--->
	<cfelse>
		<cfset indicacion = "Nueva Máquina">
	</cfif>
<cfelseif form.Paso EQ 2>
	<cfset titulo = "Impresoras por Máquina">
	<cfset indicacion = "#rsFAM09.FAM09MAQ# - #rsFAM09.FAM09DES#">
<cfelseif form.Paso EQ 3>
	<cfset titulo = "Cajas">
    <cfset indicacion = "#rsFAM09.FAM09MAQ# -  #rsFAM09.FAM09DES#">
</cfif>
<style type="text/css">
<!--
.style1 {font-size: 14px}
-->
</style>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="4">
		<tr>
			<td width="1%" align="right">
				<img border="0" src="/cfmx/sif/imagenes/number#form.Paso#_64.gif" align="absmiddle">
			</td>
			<td style="padding-left: 10px;" valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>
					</tr>
					<tr>
						<td strong align="left" nowrap bgcolor="##F2F2F2" class="tituloPersona style1"><font size="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font> #indicacion#</td>
					</tr>
				</table>
			</td>
	  	</tr>	
	</table>
</cfoutput>
