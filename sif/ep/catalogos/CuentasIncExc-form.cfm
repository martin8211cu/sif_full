
<cfset tipoCuenta = "1">

<cfif isdefined("form.ID_EstrCtaDet") and len(trim(form.ID_EstrCtaDet))>
	<cfquery name="rsCtaDet" datasource="#Session.DSN#">
		select a.ID_EstrCtaDet,a.TipoAplica,FormatoC,FormatoP
		 from CGEstrProgCtaD a
		where a.ID_EstrCtaDet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_EstrCtaDet#">
	</cfquery>
<!--- <cf_dump var="#rsCtaDet#"> --->
	<cfset modo2 = 'CAMBIO'>
	<cfset tipoCuenta = rsCtaDet.TipoAplica>
<cfelse>
	<cfset modo2 = 'ALTA'>

	<cfif isdefined("Url.t_cuenta") and Len(Trim(Url.t_cuenta))>
		<cfset tipoCuenta = Url.t_cuenta>
	</cfif>

</cfif>



<cfquery name="rsCuentaMayor" datasource="#Session.DSN#">
	select CGEPCtaMayor from CGEstrProgCtaM
    where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTiposRep.ID_Estr#">
</cfquery>

<cfoutput>
	<form name="formAinc" method="post" action="CuentasIncExc-sql.cfm" style="margin: 0;">
		<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#" tabindex="-1">
		<cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum#" tabindex="-1">
		</cfif>
        <cfif isdefined("form.ID_EstrCtaDet") and Len(Trim(form.ID_EstrCtaDet))>
            <input type="hidden" name="ID_EstrCtaDet" value="#form.ID_EstrCtaDet#" tabindex="-1">
        </cfif>

		<input type="hidden" name="ID_Estr" value="#rsTiposRep.ID_Estr#" tabindex="-1">

		<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
		  <input type="hidden" name="fID_Estr" value="#Form.fID_Estr#" tabindex="-1">
		</cfif>

		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td style="background-color:##CCCCCC" colspan="2"><strong>Cuenta</strong></td>
		  </tr>
		  <tr>
			   		<td align="right"><strong>#LB_TipoAplica#:&nbsp;</td>
					<td align="left"></strong>
                    	<select id="Tipoaplica" tabindex="1"
							onchange="javascript: submit();" name="Tipoaplica">
							<option value="1" <cfif (isdefined("rsCtaDet") and rsCtaDet.TipoAplica EQ "1") or tipoCuenta EQ "1" > selected </cfif>>Cuentas Contables</option>
							<option value="2" <cfif (isdefined("rsCtaDet") and rsCtaDet.TipoAplica EQ "2") or tipoCuenta EQ "2"> selected </cfif>>Cuentas Presupuesto</option>
						</select>

                    </td>
				</tr>
		  <!---            <cfif isdefined("form.ID_EstrCta") and Len(Trim(form.ID_EstrCta))>--->
            <cfif rsCuentaMayor.RecordCount gt 0 >
            	<cfif isdefined("form.ID_EstrCta") and Len(Trim(form.ID_EstrCta))>
                    <cfparam name="Form.ID_EstrCta" default="#form.ID_EstrCta#">
                    <input type="hidden" name="ID_EstrCta" value="#Form.ID_EstrCta#" tabindex="-1">
                </cfif>

				<cfset ValuesArray=ArrayNew(1)>
				<cfif  isdefined("rsCtaDet") >
					<cfif  rsCtaDet.TipoAplica EQ "1">
						<cfset ArrayAppend(ValuesArray,left(rsCtaDet.FormatoC,4))>
						<cfset ArrayAppend(ValuesArray,right(rsCtaDet.FormatoC,len(rsCtaDet.FormatoC)-5))>
					<cfelse>
						<cfset ArrayAppend(ValuesArray,left(rsCtaDet.FormatoP,4))>
						<cfset ArrayAppend(ValuesArray,right(rsCtaDet.FormatoP,len(rsCtaDet.FormatoP)-5))>
					</cfif>
				</cfif>
			<tr>
				<td align="right"><strong>Cuenta:&nbsp;</td>
		  		<td>

			  	 <cfif (isdefined("rsCtaDet")  and rsCtaDet.TipoAplica EQ "1") or tipoCuenta EQ "1">
				  <cf_inputCuenta
						Conexion = #Session.DSN#
						form = "formAinc"
						name = "CmayorInc"
						frame = "frmCmayor"
						Valores = "#ValuesArray#"
						descripcion = "CformatoInc"
						size = 4
						sizedesc = 25
						tabindex = "1"
					>
				<cfelse>
					<cf_inputCuenta
						Conexion = #Session.DSN#
						form = "formAinc"
						name = "CmayorInc"
						frame = "frmCmayor"
						descripcion = "CformatoInc"
						Valores = "#ValuesArray#"
						size = 4
						sizedesc = 25
						tabindex = "1"
						tipoCuenta="P"
					>
				</cfif>
				</td>
		  </tr>

            <cfelse>
            		<strong>Capturar cuenta de mayor para la estructura</strong>
				</cfif>

		  <tr>
			<td colspan="2">
				<cfif modo2 NEQ "ALTA">
					<cf_botones values="Eliminar,Nuevo" tabindex="4">
				<cfelse>
                	<!---<cfif isdefined("form.ID_EstrCta") and Len(Trim(form.ID_EstrCta))>--->
                    <cfif rsCuentaMayor.RecordCount gt 0 >
						<cf_botones values="Agregar" tabindex="5">
                    </cfif>
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		</table>
	</form>
</cfoutput>

<cf_qforms form="formAinc" objForm="objFormAinc">


<script language="JavaScript" type="text/javascript">

	<!--- function changeTipoAplica(ctl) {

		if(ctl.value == 1)
		{
			document.getElementById("trCont").style.display = "";
			document.getElementById("trPre").style.display = "none";
		}
		else
		{
			document.getElementById("trCont").style.display = "none";
			document.getElementById("trPre").style.display = "";
		}
	} --->

	//objFormAinc.ID_Estr.required = true;
	//objFormAinc.ID_Estr.required = true;

</script>
