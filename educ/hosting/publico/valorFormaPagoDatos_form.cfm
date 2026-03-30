
<!---
	UTILICE EN LA FORMA QUE HACE EL INCLUDE Y UTILIZA Qforms:
	
	<script language="JavaScript">
	//---------------------------------------------------------------------------------------		
		function deshabilitarValidacion() {
			...
			if (objForm.FPDcantidad)
				VFPDdeshabilitarValidacion();
		}
	//---------------------------------------------------------------------------------------		
		function habilitarValidacion() {
			...
			if (objForm.FPDcantidad)
				VFPDhabilitarValidacion();
		}	
	//---------------------------------------------------------------------------------------		
	
		...
		if (objForm.FPDcantidad)
			VFPDdefinirValidacion();
	</script>
--->

<!---       Consultas      --->

	<cfif isdefined("form._FPcodigo")>
		<cfquery name="rsFormD" datasource="sdc">
			select distinct convert(varchar,b.FPDcodigo) as FPDcodigo
				 , '' as FPDcodigo2
				 , FPDnombre
				 , '' as VFPDvalor
				 , FPDtipoDato, FPDlongitud, FPDdecimales, FPDobligatorio
			from FormaPago a, FormaPagoDatos b, ValorFormaPago c
			where a.FPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form._FPcodigo#">
			and a.FPcodigo=b.FPcodigo
			and a.FPcodigo=c.FPcodigo
			and b.FPcodigo=c.FPcodigo
			order by FPDorden
		</cfquery>
	<cfelse>
		<cfquery name="rsFormD" datasource="sdc">
			select convert(varchar,v.VFPcodigo) as VFPcodigo
				, convert(varchar,fpd.FPDcodigo) as FPDcodigo
				, convert(varchar,vd.FPDcodigo) as FPDcodigo2
				, FPDnombre
				, rtrim(VFPDvalor) as VFPDvalor
				, FPDtipoDato, FPDlongitud, FPDdecimales, FPDobligatorio
			from  ValorFormaPago v
				, FormaPago fp
				, ValorFormaPagoDatos vd
				, FormaPagoDatos fpd
			where  v.VFPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VFPcodigo#">
				and fp.FPcodigo=v.FPcodigo
				and fpd.FPcodigo=fp.FPcodigo
				and vd.VFPcodigo=*v.VFPcodigo
				and vd.FPDcodigo=*fpd.FPDcodigo
			order by FPDorden
		</cfquery>
	</cfif>

	<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
	<cfoutput>
		<input type="hidden" name="VFPcodigo2" value="#form.VFPcodigo#">				
		<input type="hidden" name="FPDcantidad" value="#rsFormD.RecordCount#">				
	</cfoutput>
		<table border="0" cellspacing="1" cellpadding="1">
	<cfoutput query="rsFormD">
		  <tr>
		    <td>&nbsp;
			  <input type="hidden" name="FPDcodigo_#rsFormD.currentRow#" value="#rsFormD.FPDcodigo#">
			  <input type="hidden" name="FPDcodigo2_#rsFormD.currentRow#" value="#rsFormD.FPDcodigo2#">
			</td>
	        <td align="right"><strong>#rsFormD.FPDnombre#:&nbsp;</strong></td>
		    <td>
			<cfif #rsFormD.FPDtipoDato# EQ 'P'>
			  <input type="password" name="VFPDvalor_#rsFormD.currentRow#" id="VFPDvalor" value="#rsFormD.VFPDvalor#" size="#rsFormD.FPDlongitud+2#" maxlength="#rsFormD.FPDlongitud#">
			<cfelseif #rsFormD.FPDtipoDato# EQ 'F'>
  			  <cf_sifcalendario name="VFPDvalor_#rsFormD.currentRow#" value="#rsFormD.VFPDvalor#" form="formValorFormaPagoDatos">
			<cfelseif #rsFormD.FPDtipoDato# EQ 'C' AND #rsFormD.FPDlongitud# GT 50>
			  <textarea name="VFPDvalor_#rsFormD.currentRow#" onFocus="this.select()" cols="50" rows="5" style="background-color: ##FAFAFA; font-size: xxx-small;font-family: Verdana, Arial, Helvetica, sans-serif;">#rsFormD.VFPDvalor#</textarea>
			<cfelse>
			  <input type="text" name="VFPDvalor_#rsFormD.currentRow#" id="VFPDvalor" value="#rsFormD.VFPDvalor#" size="#rsFormD.FPDlongitud+2#" maxlength="#rsFormD.FPDlongitud#"
					<cfif #rsFormD.FPDtipoDato# EQ 'N'>onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,#rsFormD.FPDdecimales#);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}} fm(this,#rsFormD.FPDdecimales#)"<cfelse>onFocus="javascript:this.value=trim(this.value); this.select();"</cfif>>
			</cfif>
			</td>
          </tr>
	</cfoutput>
	</table>
	<script language="JavaScript">
	function VFPDdefinirValidacion()
	{
	<cfoutput query="rsFormD">
	  <cfif rsFormD.FPDobligatorio EQ "1">
		objForm.VFPDvalor_#rsFormD.currentRow#.required = true;
		objForm.VFPDvalor_#rsFormD.currentRow#.description = "#rsFormD.FPDnombre#";	
	  </cfif>
	</cfoutput>
	}
	function VFPDdeshabilitarValidacion() 
	{
	<cfoutput query="rsFormD">
	  <cfif rsFormD.FPDobligatorio EQ "1">
		objForm.VFPDvalor_#rsFormD.currentRow#.required = false;		
	  </cfif>
	</cfoutput>
	}
	function VFPDhabilitarValidacion() 
	{
	<cfoutput query="rsFormD">
	  <cfif rsFormD.FPDobligatorio EQ "1">
		objForm.VFPDvalor_#rsFormD.currentRow#.required = true;		
	  </cfif>
	</cfoutput>
	}	
	</script>
