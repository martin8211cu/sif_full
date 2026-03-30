<cfquery name="datorequisito" datasource="#session.tramites.dsn#" >
	select 	tc.id_tipo, 
			dr.id_requisito, 
			tc.nombre_campo,
		    tc.id_campo,	 
		    tc.nombre_campo, 
			tp.tipo_dato,
			tp.formato,
			tp.mascara,
		    tp.clase_tipo, 
		    tp.tipo_dato, 
		    tp.mascara, 
		    tp.formato, 
		    tp.valor_minimo, 
		    tp.valor_maximo, 
		    tp.longitud, 
		    tp.escala, 
		    tp.nombre_tabla,

			<cfif Len(instancia.id_instancia)>
				cam.valor 
			<cfelse>
				null
			</cfif> as valor
	from TPRequisito dr
		join TPDocumento d
			on d.id_documento = dr.id_documento
		join DDTipoCampo tc
			on tc.id_tipo = d.id_tipo
		join DDTipo tp
			on tp.id_tipo = tc.id_tipocampo
		<cfif Len(instancia.id_instancia)>
		left join TPInstanciaRequisito ir
			on ir.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_instancia#">
			and ir.id_requisito = dr.id_requisito
		left join DDRegistro reg
			on reg.id_registro = ir.id_registro
		left join DDCampo cam
			on cam.id_registro = reg.id_registro
			and cam.id_campo = tc.id_campo
		</cfif>
	where dr.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
</cfquery>

<cfset datos_var = ''>
<cfif datorequisito.RecordCount>
	<cfsavecontent variable="datos_var">
		<cfoutput query="datorequisito">
			<input type="hidden" name="id_campo" value="#datorequisito.id_campo#">
			<input type="hidden" name="id_requisito_#datorequisito.id_campo#" value="#datorequisito.id_requisito#">
			<cfif listfind(requisitos,  datorequisito.id_requisito) eq 0>
				<cfset requisitos = listappend(requisitos, datorequisito.id_requisito ) >
			</cfif>
		</cfoutput>
	<table width="480" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid black;background-color:#ededed ">
		<cfoutput query="datorequisito">
			<tr>
				<cfif datorequisito.tipo_dato eq 'B' >
					<td colspan="2">
						<!--- check --->
							<input type="checkbox" name="dato_#datorequisito.id_campo#" id="dato_#datorequisito.id_campo#" 
								<cfif len(trim(valor)) and valor eq 1 >checked</cfif> >
							<label for="dato_#datorequisito.id_campo#">
							<strong>#datorequisito.nombre_campo#</strong></label>
					</td>
				<cfelse>
					<td nowrap>
						<label for="dato_#datorequisito.id_campo#">
							<strong>#datorequisito.nombre_campo#</strong></label>
					</td>
					<td>
						<input type="text" name="dato_#datorequisito.id_campo#" 
							id="dato_#datorequisito.id_campo#" 
							value="#HTMLEditFormat(valor)#">
					</td>
				</cfif>
			</tr>
			
		</cfoutput>
		<tr><td colspan="2">
			<cfoutput>
			<input type="checkbox" name="completado_#instancia.id_requisito#" id="completado_#instancia.id_requisito#" value="1" <cfif instancia.completado>checked</cfif> >
			<label for="completado_#instancia.id_requisito#">
			 <strong>Marcar el requisito como completado</strong></label>
			 </cfoutput>
			 </td></tr>
	</table>
	</cfsavecontent>
</cfif>