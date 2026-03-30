<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfquery datasource="#Session.DSN#" name="rsHtipocambio">
	select tc.Mcodigo, m.Mnombre, tc.TCperiodo, tc.TCmes, tc.TCtipocambio, tc.ts_rversion 
	from TipoCambioReporte tc, Monedas m
	where tc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("Form.Mcodigo") and form.Mcodigo NEQ "">
		and tc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Form.Mcodigo#">
	</cfif>	
	<cfif isdefined("Form.TCperiodo") and form.TCperiodo NEQ "">
		and tc.TCperiodo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Form.TCperiodo#">
	</cfif>	
	<cfif isdefined("Form.TCmes") and form.Mcodigo NEQ "">
		and tc.TCmes = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Form.TCmes#">
	</cfif>	
	  and tc.Ecodigo = m.Ecodigo
	  and tc.Mcodigo = m.Mcodigo
</cfquery>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
</cfquery>

<cfquery name="periodo_desde" datasource="#Session.DSN#">
    select distinct coalesce ( min (Speriodo ), # Year(Now()) - 3 #) as Speriodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Speriodo desc
</cfquery>
<cfquery name="periodo_hasta" datasource="#Session.DSN#">
    select distinct coalesce ( max (Speriodo ), # Year(Now()) + 3 #) as Speriodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Speriodo desc
</cfquery>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Periodo 	= t.Translate('LB_Periodo','Periodo','TipoCambioRep.cfm')>
<cfset LB_Mes 		= t.Translate('CMB_Mes','Mes','/sif/generales.xml')>
<cfset LB_Tipo_de_Cambio = t.Translate('LB_Tipo_de_Cambio','Tipo de Cambio','/sif/generales.xml')>
<cfset CMB_Enero 	= t.Translate('CMB_Enero','Enero','/sif/generales.xml')>
<cfset CMB_Febrero 	= t.Translate('CMB_Febrero','Febrero','/sif/generales.xml')>
<cfset CMB_Marzo 	= t.Translate('CMB_Marzo','Marzo','/sif/generales.xml')>
<cfset CMB_Abril 	= t.Translate('CMB_Abril','Abril','/sif/generales.xml')>
<cfset CMB_Mayo 	= t.Translate('CMB_Mayo','Mayo','/sif/generales.xml')>
<cfset CMB_Junio 	= t.Translate('CMB_Junio','Junio','/sif/generales.xml')>
<cfset CMB_Julio 	= t.Translate('CMB_Julio','Julio','/sif/generales.xml')>
<cfset CMB_Agosto 	= t.Translate('CMB_Agosto','Agosto','/sif/generales.xml')>
<cfset CMB_Septiembre = t.Translate('CMB_Septiembre','Septiembre','/sif/generales.xml')>
<cfset CMB_Octubre = t.Translate('CMB_Octubre','Octubre','/sif/generales.xml')>
<cfset CMB_Noviembre = t.Translate('CMB_Noviembre','Noviembre','/sif/generales.xml')>
<cfset CMB_Diciembre = t.Translate('CMB_Diciembre','Diciembre','/sif/generales.xml')>
<cfset LB_Conversion = t.Translate('LB_Conversion','Conversion')>

//-->
</script>
<cfset LvarAction = 'SQLTipocambiorep.cfm'>
<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="form1">
<cfoutput>
  <table align="center">
		<tr valign="baseline"> 
      		<td nowrap align="right"><strong>#LB_Moneda#:&nbsp;</strong></td>
      		<td>			
			<cfif MODO EQ "ALTA">
				<cf_sifmonedas tabindex="1">
				
				<!--- Quita del combo la moneda local --->
				<script language="JavaScript1.2">
					var existeMonedaLocal = false;
					var long = document.form1.Mcodigo.length;
					for (var i = 0; i < long - 1; i++) {
						if (document.form1.Mcodigo.options[i].value == "<cfoutput>#Trim(rsMonedaLocal.Mcodigo)#</cfoutput>") 
							existeMonedaLocal = true;				
						if (existeMonedaLocal) {
							document.form1.Mcodigo.options[i].value = document.form1.Mcodigo.options[i+1].value; 
							document.form1.Mcodigo.options[i].text = document.form1.Mcodigo.options[i+1].text; 
						}
					}
					document.form1.Mcodigo.length = long - 1;
				</script>
			<cfelse>
				<input type="text" name="Mnombre" value="<cfoutput>#rsHtipocambio.Mnombre#</cfoutput>"  size="30" maxlength="30" readonly="readonly" tabindex="1">
				<input type="hidden" name="Mcodigo" value="<cfoutput>#rsHtipocambio.Mcodigo#</cfoutput>">
			</cfif>
			</td>
    	</tr>
    	<tr valign="baseline">
      		<td valign="middle"><div align="right"><strong>#LB_Periodo#:</strong>&nbsp;</div></td>
		    <td colspan="2">
			<cfif MODO EQ "ALTA">
                <select name="TCperiodo" tabindex="1">
                    <cfloop from="#periodo_desde.Speriodo#" to="#periodo_hasta.Speriodo#" index="Speriodo">
                      <option value="#Speriodo#">#Speriodo#</option>
                    </cfloop>
                </select>
			<cfelse>
				<input name="TCperiodo" type="text" value="#rsHtipocambio.TCperiodo#" size="4" maxlength="4"  tabindex="2" readonly alt="El campo Periodo"/>
			</cfif>				
			</td>
		</tr>
    	<tr valign="baseline"> 
            <td align="right" ><strong>#LB_Mes#:</strong></td>
            <td width="23%">
           		<cfif modo NEQ 'ALTA'>
                	<cfswitch expression="#rsHtipocambio.TCmes#" >
                    	<cfcase value="1" >
                        	#CMB_Enero# </cfcase>
                    	<cfcase value="2" >
                        	#CMB_Febrero# </cfcase>
                    	<cfcase value="3" >
                        	#CMB_Marzo# </cfcase>
                    	<cfcase value="4" >
                        	#CMB_Abril# </cfcase>
                    	<cfcase value="5" >
                        	#CMB_Mayo# </cfcase>
                    	<cfcase value="6" >
                        	#CMB_Junio# </cfcase>
                    	<cfcase value="7" >
                        	#CMB_Julio# </cfcase>
                    	<cfcase value="8" >
                        	#CMB_Agosto# </cfcase>
                    	<cfcase value="9" >
                        	#CMB_Septiembre# </cfcase>
                    	<cfcase value="10" >
                        	#CMB_Octubre# </cfcase>
                    	<cfcase value="11" >
                        	#CMB_Noviembre# </cfcase>
                    	<cfcase value="12" >
                        	#CMB_Diciembre# </cfcase>
                    </cfswitch>
                    <input type="hidden" name="TCmes" value="#rsHtipocambio.TCmes#">
              	<cfelse>
                  <select name="TCmes" size="1" tabindex="2">
                      <option value="1" >#CMB_Enero#</option>
                      <option value="2" >#CMB_Febrero#</option>
                      <option value="3" >#CMB_Marzo#</option>
                      <option value="4" >#CMB_Abril#</option>
                      <option value="5" >#CMB_Mayo#</option>
                      <option value="6" >#CMB_Junio#</option>
                      <option value="7" >#CMB_Julio#</option>
                      <option value="8" >#CMB_Agosto#</option>
                      <option value="9" >#CMB_Septiembre#</option>
                      <option value="10">#CMB_Octubre#</option>
                      <option value="11">#CMB_Noviembre#</option>
                      <option value="12">#CMB_Diciembre#</option>
                  </select>
                </cfif>
            </td> 
    	</tr>

    	<tr valign="baseline"> 
      		<td nowrap align="right"><strong>#LB_Tipo_de_Cambio#:&nbsp;</strong></td>
      		<td>
				<input type="text" name="TCtipocambio" tabindex="3" value="<cfif modo NEQ 'ALTA'>#rsHtipocambio.TCtipocambio#</cfif>"  size="10" maxlength="10" style="text-ali gn: right;" onblur="javascript:fm(this,4);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" alt="El Tipo de cambio de conversión de reporte">
			</td>
    	</tr>
    	<tr valign="baseline"> 
      		<td nowrap align="right"><strong>(#LB_Conversion#)</strong></td>
        </tr>
		<tr valign="baseline"> 
			<cfset tabindex = 1>
			<td colspan="2" align="right" nowrap><cfinclude template="../../portlets/pBotones.cfm"></td>
		</tr>
  </table>
</cfoutput>

	<cfset ts = "">	
  <cfif modo neq "ALTA">
		<cfinvoke 
		 component="sif.Componentes.DButils"
		 method="toTimeStamp"
		 returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsHtipocambio.ts_rversion#"/>
		</cfinvoke>
  </cfif>
  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
</form>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<cfif modo neq 'ALTA'>
		fm(document.form1.TCtipocambio,4);
	</cfif>
</script>