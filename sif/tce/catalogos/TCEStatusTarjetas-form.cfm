<!---
	Catalogo de Status de las tarjetas de credito
	Creado por Hector Garcia Beita
	Fecha: 22/07/2011
--->
<cfset modo = 'ALTA'>
 
<cfif isdefined('form.CodigoTarjeta') and len(trim(form.CodigoTarjeta))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
    <cfquery name="data" datasource="#session.DSN#">	
        Select CBSTid
              ,CBSTcodigo as CodigoTarjeta
              ,CBSTDescripcion as Descripcion
              ,CBSTActiva
              ,ts_rversion
        from CBStatusTarjetaCredito 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and CBSTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CodigoTarjeta#">
   </cfquery>
</cfif>
 
<cfoutput>
    <form name="form1" method="post" action="TCEStatusTarjetas-sql.cfm" onSubmit="javascript: return validaMon();">
		<table width="100%" cellpadding="3" cellspacing="0">
			<cfif isdefined('form.Descripcion_U') and len(trim(form.Descripcion_U))>
                <input type="hidden" name="Descripcion_U" value="#form.Descripcion_U#">
            </cfif>
             <tr>
                <td align="right"><strong>C&oacute;digo</strong></td>
                <td>
                    <input type="text" name="CodigoTarjeta" size="20" maxlength="10" value="<cfif modo neq 'ALTA'>#data.CodigoTarjeta#</cfif>">
                </td>
            </tr>
		
			<tr>
                <td align="right"><strong>Descripci&oacute;n</strong></td>
                <td >
                    <input type="text" name="Descripcion" size="40" maxlength="80" value="<cfif modo neq 'ALTA'>#data.Descripcion#</cfif>">
                </td>
			</tr>
            <tr>
            	<td align="right"></td>
                <td>
                	<table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
						<td width="1%">
								<input name="StatusTC" type="checkbox"
								<cfif modo neq 'ALTA'>
								<cfif data.CBSTActiva EQ 1>checked</cfif></cfif>>
						</td>
						<td ><strong>Activa/Inactiva</strong></td>
					</tr>
  					</table>		
			  </td>
		  </tr>
			<tr>
				<td colspan="2" align="center">
					<cfif modo neq 'ALTA'  >
                        <cf_botones modo='CAMBIO'>
                     <cfelse>
                        <cf_botones modo='ALTA'>
                    </cfif>
				</td>
		   </tr>
	</table>

	<cfif modo neq 'ALTA'>
            <cfset ts = "">
            <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
                artimestamp="#data.ts_rversion#" returnvariable="ts">
            </cfinvoke>            
            <input type="hidden" name="CBSTid" value="#data.CBSTid#">
            <input type="hidden" name="ts_rversion" value="#ts#">
    </cfif>
  	</form>

<!-- MANEJA LOS ERRORES  NOTA:QUE REVISEN ESTO EN LA BD! --->
<cf_qforms>
	<script language="javascript" type="text/javascript">
        <!--//
        objForm.Descripcion.description = "Descripci\u00f3n";
 		objForm.CodigoTarjeta.description = "C\u00f3digo";
        
		function validaMon(){
            return true;
        }	
        
        function habilitarValidacion(){
            objForm.Descripcion.required = true;
			objForm.CodigoTarjeta.required = true;
        }
        function deshabilitarValidacion(){
            objForm.Descripcion.required = false;
 			objForm.CodigoTarjeta.required = false;
         }
        habilitarValidacion();
        //-->
    </script>
</cfoutput>




