<cfparam name="modo" default="ALTA">
<cfif isdefined('Form.AnexoCelDid2') and len(trim(Form.AnexoCelDid2)) GT 0 or (isdefined("Form.AnexoCelDid") and len(trim(Form.AnexoCelDid)) GT 0) >
	<cfset modo = "CAMBIO">
</cfif>

<cfquery name="rsLinea" datasource="#Session.DSN#">
	select 
		<cf_dbfunction name="to_char" args="a.AnexoCelDid"> as AnexoCelDid, 
		<cf_dbfunction name="to_char" args="a.AnexoCelId">  as AnexoCelId, 
		a.AnexoCelFmt, 
		a.AnexoCelFmt as Cformato, 
		a.AnexoCelMov,
		'' as Cdescripcion,
		'' as Ccuenta	
	from AnexoCelD a
	where a.AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
	<cfif isdefined("Form.AnexoCelDid")>
	  and a.AnexoCelDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelDid#">
	<cfelseif isdefined("Form.AnexoCelDid2")>
	  and a.AnexoCelDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelDid2#">
	</cfif>
</cfquery>

<cfif modo neq 'ALTA'>
	<cfset formato = ListToArray(rsLinea.Cformato, '%')>
	<cfloop  from="1" index="i" to="#ArrayLen(formato)#" >
		<cfset vFormato = trim(formato[i])>
	</cfloop>

	<cfset vDescripcion = '' >
	<cfif ArrayLen(formato) gt 0>
		<cfquery name="descripcion" datasource="#session.DSN#">
			select Cdescripcion 
			from CContables 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
			and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(formato[1])#">
		</cfquery>
	
		<cfif descripcion.RecordCount gt 0>
			<cfset vDescripcion = descripcion.Cdescripcion >
		</cfif>
	</cfif>
	
	<cfif len(trim(rsLinea.Cdescripcion)) gt 0>
		<cfset vDescripcion = rsLinea.Cdescripcion >
	</cfif>

	<cfset rsCuenta = QueryNew("Cformato,AnexoCelDid,AnexoCelId,AnexoCelFmt,Cdescripcion,Ccuenta")>
	<cfset temp = QueryAddRow(rsCuenta,1)>
	<cfset temp = QuerySetCell(rsCuenta, "Cformato", trim(vformato), 1)>
	<cfset temp = QuerySetCell(rsCuenta, "AnexoCelDid", trim(rsLinea.AnexoCelDid), 1)>
	<cfset temp = QuerySetCell(rsCuenta, "AnexoCelId", trim(rsLinea.AnexoCelId), 1)>
	<cfset temp = QuerySetCell(rsCuenta, "AnexoCelFmt", trim(rsLinea.AnexoCelFmt), 1)>
	<cfset temp = QuerySetCell(rsCuenta, "Cdescripcion", vDescripcion, 1)>
	<cfset temp = QuerySetCell(rsCuenta, "Ccuenta", '', 1)>
</cfif>

<cfoutput>
 <form method="post" name="form1" action="SQLAnexoCelD.cfm" onSubmit="return validar();">
    <table align="center">
    <tr valign="baseline"> 
      <td nowrap align="right" valign="middle">Formato de Cuenta:</td>
      <td>
	  	<cfif modo EQ "ALTA">
			<cf_cuentasAnexo 
				AUXILIARES="S" 
				MOVIMIENTO="N"
				CONLIS="S"
				ccuenta="Ccuenta" 
				cdescripcion="Cdescripcion" 
				cformato="Cformato" 
				conexion="#Session.DSN#"
				form="form1"
				frame="frAn"
				comodin="_">
		<cfelse>	
			<cf_cuentasAnexo 
				AUXILIARES="S" 
				MOVIMIENTO="N"
				CONLIS="S"
				ccuenta="Ccuenta" 
				cdescripcion="Cdescripcion" 
				cformato="Cformato" 
				conexion="#Session.DSN#"
				form="form1"
				query="#rsCuenta#"
				frame="frAn"
				comodin="_">
		</cfif>
	  </td>
    </tr>
    <tr valign="baseline"> 
        <td nowrap align="right">&nbsp;</td>
        <td valign="middle"> 
          <input type="checkbox" name="AnexoCelMov" 
		  value="<cfif modo neq "ALTA">#rsLinea.AnexoCelMov#</cfif>"
		  <cfif rsLinea.AnexoCelMov EQ 'S'>checked</cfif>
		  >
          Solo Cuentas que aceptan Movimiento</td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="right" nowrap><div align="center"><cfinclude template="../../portlets/pBotones.cfm">
            <input type="Button" name="btnRegresar" value="Regresar" onclick="javascript:document.location.href='Definirdatos.cfm?AnexoID=#Form.AnexoId#'">
          </div></td>
    </tr>
  </table>
  <input type="hidden" name="AnexoCelDid" value="<cfif isdefined('Form.AnexoCelDid2')>#Form.AnexoCelDid2#<cfelseif isdefined("Form.AnexoCelDid")>#Form.AnexoCelDid#</cfif>">
  <input type="hidden" name="AnexoCelId" value="#Form.AnexoCelId#">
  <input type="hidden" name="AnexoId" value="#Form.AnexoId#">
</form>
</cfoutput>
<script language="JavaScript1.2">
	document.form1.Cformato.focus();

	function validar(){
		//if ( document.form1.Cformato.value.length == 0 || document.form1.Cmayor.value.length == 0 ){
		if ( document.form1.Cmayor.value.length == 0 ){
			alert('Se presentaron los siguientes errores:\n - El campo Formato de Cuenta es requerido.')
			return false;
		}
		return true;
	}
</script>