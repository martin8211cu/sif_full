<cfset modo = 'ALTA'>
<cfif  isdefined('form.FAM01COD') and len(trim(form.FAM01COD))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select Ocodigo, FAM01COD, FAM01CODD, FAM09MAQ, FAM01DES, FAM01RES, FAM01TIP, FAM01COB,
		FAM01STS, FAM01STP,CFcuenta, I02MOD, CCTcodigoAP, CCTcodigoDE, CCTcodigoFC, CCTcodigoCR,
		CCTcodigoRC, FAM01NPR, FAM01NPA, Aid, Mcodigo, FAM01TIF, FAPDES, ts_rversion
		from FAM001
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01COD#">
		
	</cfquery>

	<!--- QUERY PARA el tag de Oficinas--->
	<cfif len(trim(data.Ocodigo))>
		<cfquery name = "rsOficinas" datasource="#session.DSN#">
			Select Ocodigo, Oficodigo, Odescripcion
		    from Oficinas
		    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Ocodigo=<cfqueryparam value="#data.Ocodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
</cfif>


<cfoutput>
<form name="form1" method="post" action="apertura_cajas-sql.cfm" onSubmit="javascript: return validarCajas();">
	<input type="hidden" name="FAM01COD" value="<cfif modo neq 'ALTA'>#data.FAM01COD#</cfif>">
	
	<table width="100%" cellpadding="3" cellspacing="0">
			<tr>
            	<td align="right"><strong>C&oacute;digo</strong></td>
            	<td><input type="text" readonly="true" name="FAM01CODD" size="10" maxlength="4" value="<cfif modo neq 'ALTA'>#data.FAM01CODD#</cfif>"></td>
          	</tr>		
			<tr>
            	<td align="right"><strong>Descripci&oacute;n</strong></td>
            	<td><strong>
            	  <input type="text" readonly="true" name="FAM01DES" size="40" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM01DES#</cfif>">
            	</strong></td>
          	</tr>		
			<tr>
            	<td align="right"><strong>Oficina</strong></td>
				<td>
					<cfif modo NEQ 'ALTA' and len(trim(data.Ocodigo))>
        				<cf_sifoficinas form="form1" id="#rsOficinas.Ocodigo#" modificable = "false">
        			<cfelse>
        				<cf_sifoficinas form="form1">
      				</cfif>
				</td>
          	</tr>			
			<tr>
            	<td align="right"><strong>Estatus</strong></td>
            	<td><strong>
            	  <select  name="FAM01STS" disabled>
                    <option value="1"<cfif modo NEQ 'ALTA' and data.FAM01STS EQ 1> selected </cfif>>Caja Abierta</option>
                    <option value="0"<cfif modo NEQ 'ALTA' and data.FAM01STS EQ 0> selected </cfif>>Caja Cerrada</option>
                  </select>
            	</strong></td>
          	</tr>								
          	<tr>
         		<td align="right"><strong>Responsable</strong></td>
           		<td><strong>
           		  <input type="text" readonly="true" name="FAM01RES" size="20" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM01RES#</cfif>">
           		</strong></td>
          	</tr>
          	<tr>
         		<td align="right"><strong>Proceso</strong></td>
           		<td><select name="FAM01STP" disabled>
                  <option value="0"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 10> selected </cfif>>Apertura de Caja</option>
                  <option value="10"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 10> selected </cfif>>Registro de Transacciones</option>
                  <option value="30"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 30> selected </cfif>>Cierre de Usuario</option>
                  <option value="40"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 40> selected </cfif>>Cierre de Supervisor</option>
                  <option value="50"<cfif modo NEQ 'ALTA' and data.FAM01STP EQ 50> selected </cfif>>Cierre Diario Contabilizado</option>
                </select></td>
          	</tr>
          	<tr>
           		<td colspan="2">&nbsp;</td>
			</tr>
          	<tr>
           		<td colspan="2">
					<cfif modo neq 'ALTA'>
						<cf_botones modo="Cambio" exclude="Cambio,Baja,Nuevo" include="Abrir_Caja">
					<cfelse>
						<cf_botones modo="Alta" exclude="Alta,Limpiar" include="Abrir_Caja">							
					</cfif>
				</td>
			</tr>					
	</table>		
		<cfif modo neq 'ALTA'>
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>
</form>
	<script language="javascript">
		function validarCajas(){
			if(document.form1.FAM01COD.value == ''){
				alert('Error, debe seleccionar una caja de la lista');
				return false;
			}
			
			return true;
		}
	
	</script>
</cfoutput>
