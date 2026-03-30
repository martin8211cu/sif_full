
<!--- Establecimiento del modo --->
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

<cfif modo neq 'ALTA'>
    <cfquery name="rsClasificacion" datasource="#session.DSN#">
        select Ccodigo,Ccodigoclas, Cdescripcion
        from Clasificaciones
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
          and Ccodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ccodigo#">
    </cfquery>
    
    <cfquery name="rsAlmacen" datasource="#session.DSN#">
        select Aid, Almcodigo, Bdescripcion
        from Almacen
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        and Aid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Aid#">
    </cfquery>
<!---    <cf_dump var="#Form.Aid#">
---></cfif>


<cfif isdefined("Session.Ecodigo") AND isdefined("Form.Ccodigo") AND Len(Trim(Form.Ccodigo)) GT 0 
								   AND isdefined("Form.Aid") AND Len(Trim(Form.Aid)) GT 0>
<!--- <cf_dump var="#Form.Ccodigo#">                                  
 <cf_dump var="#Session.Ecodigo#"> 
<cf_dump var="#Form.Aid#">  --->
                                   
	<cfquery name="rsProdClasifAlmacen" datasource="#Session.DSN#">
    	select p.Ecodigo, p.Ccodigo, p.Almid, c.Cdescripcion, a.Bdescripcion, p.ts_rversion from
          Prod_ClasificacionAlmacen p
          inner join clasificaciones c on
              p.Ecodigo = c.Ecodigo
              and p.Ccodigo = c.Ccodigo
          inner join Almacen a on
              p.Ecodigo = a.Ecodigo
              and p.Almid = a.Aid
		where P.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
   		  and p.Almid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
          and p.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ccodigo#">
          order by p.Ccodigo, p.Almid
	</cfquery>
</cfif>

<form method="post" name="form1" action="SQLAlmacenesXCateg.cfm" onSubmit="return valida();">
	<cfoutput>
	<input type="hidden" name="filtro_Ccodigo" value="<cfif modo neq 'ALTA'> #rsClasificacion.Ccodigo# </cfif>">
    <input type="hidden" name="filtro_Almid" value="<cfif modo neq 'ALTA'> #rsAlmacen.aid# </cfif>">
    </cfoutput>
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
    	<tr>
            <td></td>
            <td>
            <table>
            	<tr>
                <td width="50%" align="left"><b>C&oacute;digo</b></td>
                <td width="50%" align="left"><b>Descripci&oacute;n</b></td>
                </tr>
            </table>
            </td>
    	</tr>
        <tr>
            <td align="right" nowrap valign="middle"><strong>Categor&iacute;a:</strong></td>
            <td>
                <cfoutput>
                <cfif modo neq 'ALTA'>
                    <cf_sifclasificacion query="#rsClasificacion#" name="Ccodigoclas" desc="Cdescripcion" tabindex="1">
                <cfelse>
                    <cf_sifclasificacion name="Ccodigoclas" desc="Cdescripcion" tabindex="1">
                </cfif>
                </cfoutput>
            </td>
        </tr>
        
        <tr>
            <td align="right" nowrap valign="middle"><strong>Almac&eacute;n:</strong></td>
            <td>
                <cfoutput>
                <cfif modo neq 'ALTA'>
                    <cf_sifalmacen query="#rsAlmacen#" id="#rsAlmacen.Aid#" name="Almcodigo" desc="Bdescripcion" tabindex="2">
                <cfelse>
                    <cf_sifalmacen name="Almcodigo" desc="Bdescripcion" tabindex="2">
                </cfif>
                </cfoutput>
            </td>
        </tr>

		<tr> 
			<td colspan="2" align="center" nowrap>
				<cfset ts = "">
                <cfif modo NEQ "ALTA">
                    <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsProdClasifAlmacen.ts_rversion#" returnvariable="ts"></cfinvoke>
                </cfif>		  
                <input  tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">	  
                <cfset tabindex= 2 >
                <cfinclude template="../../../sif/portlets/pBotones.cfm">
			</td>
		</tr>
	</table>
</form>

<!----*************************************************************--->
<script language="JavaScript1.2" type="text/javascript">
	function valida(){
		var error = false;
		var mensaje = "Se presentaron los siguientes errores:\n";
		if (document.form1.Ccodigoclas.value == '' ){
			error = true;
			mensaje += " - El campo Codigo de Clasificacion es requerido.\n";
		}
		if (document.form1.Almcodigo.value == '' ){
			error = true;
			mensaje += " - El campo Codigo de Almacen es requerido.\n";
		}		
		if ( error ){
			alert(mensaje);
			return false;
		}else{
			return true;
		}
	}
</script>