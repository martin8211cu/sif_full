
<cfif isdefined("Form.OTcodigo") AND Len(Trim(Form.OTcodigo)) GT 0>
<!---	<cfparam name="Form.CHK" default="">
--->    
	<cfquery name="rsProdArea" datasource="#session.DSN#">
    select p.OTseq, a.APcodigo, a.APDescripcion 
    from Prod_Area a
    left join (select Ecodigo,OTcodigo,APcodigo,OTseq from Prod_Proceso 
              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
              and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">) p on p.Ecodigo=a.Ecodigo and p.APcodigo=a.APcodigo
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        order by a.Ecodigo,APcodigo
    </cfquery>
	
	<cfoutput>
    <cfset NumprodArea = #rsProdArea.recordCount# >
    <form method="post" name="formArea" style="margin:0" action="SQLOrdenTr1.cfm" >    
        <input type="hidden" name="OTCodigo" value= "#Form.OTcodigo#" />
        <input type="hidden" name="NprodArea" value="#NumprodArea#"/>
        <input name="tab" type="hidden" value="area" >
        <table align="center" width="100%" cellpadding="0" cellspacing="0">
            <tr> 
                <td class="tituloListas" width="1%" colspan="3" align="center">Areas</td>
            </tr>
            <tr>
                <td class="tituloListas" align="left" width="1%">Paso</td>
                <td class="tituloListas" align="left" width="1%">Area</td>
                <td class="tituloListas" align="left" width="1%">Todos</td>
            </tr>
            <tr>
            	<td class="tituloListas" align="left" width="1%" colspan="2"></td>
        		<td class="tituloListas" align="left" width="1%"><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
            </tr> 
			<cfloop query="rsProdArea">
				<cfset LvarListaNon = (CurrentRow MOD 2)>
				<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
            	<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">
                    <td align="left" width="1%" nowrap><input type="hidden" name="APCodigo#CurrentRow#" value= "#rsProdArea.APcodigo#" />
                    	<input type="text" name= "Orden#CurrentRow#" size="3" maxlength="2" value= "#rsProdArea.OTseq#">
                    </td>                    
                	<td align="left" class="pStyle_Ddocumento" nowrap  onmouseover="javascript:  window.status = '';  return true;" onmouseout="javascript:  window.status = '';  return true;">#rsProdArea.APDescripcion#</td>
                	<td align="left" width="1%">
                        <input type="checkbox" name="chk#CurrentRow#" onclick="javascript: unMarkOne(); void(0);" style="border:none; background-color:inherit;" <cfif Len(rsProdArea.OTseq)>checked</cfif>>
                    </td> 
                </tr>
                
            </cfloop>
            <tr> 
                <td colspan="3"><div align="center"> <input type="submit" name="Aceptar_Area" value="Aceptar" > 
                </div> </td>
            </tr>
		</table>
    </form>
    </cfoutput>
<!----*************************************************************--->
<script type="text/javascript" language="JavaScript"> 
	function check_all(obj){
		for (i=1;i<=<cfoutput>#NumprodArea#</cfoutput>;i++){
				document.formArea['chk'+i].checked = "checked";
		}
	}
	function unMarkOne(){
		document.formArea.chkall.checked = false;
	}
</script>
    
</cfif>