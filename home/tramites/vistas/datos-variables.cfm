
<cfquery name="datorequisito" datasource="#session.tramites.dsn#" >
	select 	tc.id_tipo, 
			dr.id_requisito, 
			tc.nombre_campo,
		    tc.id_campo,
		    tc.nombre_campo,
			tc.id_tipocampo, 
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
			dr.id_vista,
			dr.id_vistapopup,
			dr.es_vistapopup,
			<cfif Len(instancia.id_instancia)>
				cam.valor as valor,
				cam.valor_ref as valor_ref,
			<cfelse>
				null as valor,
				null as valor_ref,
			</cfif>
			<cfif Len(instancia.id_instancia)>
				cam.id_registro
			<cfelse>
				null
			</cfif> as id_registro

		from TPRequisito dr
		join TPDocumento d
			on d.id_documento = dr.id_documento
		join DDTipoCampo tc
			on tc.id_tipo = d.id_tipo
		join DDTipo tp
			on tp.id_tipo = tc.id_tipocampo
			
		join DDVista v
			on v.id_vista = dr.id_vista
		join DDVistaCampo vc
			on vc.id_vista = dr.id_vista
			and vc.id_campo = tc.id_campo
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
	order by vc.orden_campo
</cfquery>

<cfset datos_var = ''>
<cfset popup = 0>
<cfif datorequisito.RecordCount>
	<cfsavecontent variable="datos_var"> 
		<cfoutput query="datorequisito">
			<input type="hidden" name="id_requisito_#datorequisito.id_requisito#_#datorequisito.id_campo#" value="#datorequisito.id_requisito#">
			<cfif listfind(requisitos,  datorequisito.id_requisito) eq 0>
				<cfset requisitos = listappend(requisitos, datorequisito.id_requisito ) >
			</cfif>
			<cfif listfind(campos,  datorequisito.id_campo) eq 0>
				<cfset campos = listappend(campos, datorequisito.id_campo ) >
			</cfif>
		</cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid gray; ">
		<tr><td colspan="3"><table><tr><td><cfoutput><img src="/cfmx/home/tramites/images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#">&nbsp;</td><td>#estado#</cfoutput></td></tr></table> </td></tr>
		<cfoutput query="datorequisito">
			<tr>
			<td width="1%" nowrap>
				<label for="dato_#datorequisito.id_campo#">
				<strong>#datorequisito.nombre_campo#:&nbsp;</strong></label>
			</td>
			<td>
				<cf_tipo clase_tipo="#datorequisito.clase_tipo#" 
						 name="dato_#datorequisito.id_requisito#_#datorequisito.id_campo#" 
						 id_tipo="#datorequisito.id_tipo#" 
						 tipo_dato="#datorequisito.tipo_dato#" 
						 mascara="#datorequisito.mascara#" 
						 formato="#datorequisito.formato#" 
						 valor_minimo="#datorequisito.valor_minimo#" 
						 valor_maximo="#datorequisito.valor_maximo#" 
						 longitud="#datorequisito.longitud#" 
						 escala="#datorequisito.escala#" 
						 nombre_tabla="#datorequisito.nombre_tabla#"
						 value="#datorequisito.valor#"
						 id_tipocampo="#id_tipocampo#"
						 form="form#datorequisito.id_requisito#"
						 valueid="#datorequisito.valor_ref#">	
			</td>
			<td align="right" width="16">
				<cfif isdefined('popup') and popup EQ 0 and datorequisito.es_vistapopup>
					<a href="javascript: vistaRequisito('#id_registro#','#id_tipo#','#id_vistapopup#','#instancia.id_persona#','#tramite.id_tramite#','#datorequisito.id_requisito#');">
				<img alt="Ver datos de la Vista" 
					src="../../images/popup.gif" border="0"></a>
				<cfset popup = 1>
				<cfelse>&nbsp;
				</cfif>
			</td>
			</tr>
		</cfoutput>
		
<!---
		<tr><td colspan="3">
			<cfoutput>
			<input type="checkbox" name="completado_#instancia.id_requisito#" id="completado_#instancia.id_requisito#" value="1" <cfif instancia.completado>checked</cfif> >
			<label for="completado_#instancia.id_requisito#">
			 <strong>Marcar el requisito como completado</strong></label>
			 </cfoutput>
			 </td></tr>
--->			 
		<cfoutput>
			<tr><td colspan="3">#tiene_cita#</td></tr>
			<tr><td colspan="3">#tiene_conexion#</td></tr>
			
			<!--- el componente de criterios se instancia donde se hace el include de este archivo (ventanilla/datos-variables.cfm) --->
			<cfif not criterios.hay_criterios(instancia.id_requisito) >
				<tr><td colspan="2">
					<table cellpadding="0" cellspacing="0">
						<tr>
							<td width="1%">
								<input type="checkbox" name="completado" id="completado_#instancia.id_requisito#"
									<cfif instancia.rechazado EQ 0 and instancia.completado EQ 1>checked</cfif>
								>
							</td>
							<td>
								#instancia.texto_completado#
							</td>
						</tr>
					</table>
	
				</td></tr>
			</cfif>

<!--- ====================================== --->
<tr><td colspan="2"><cfinclude template="../Operacion/ventanilla/flujo.cfm"></td></tr>
<!--- ====================================== --->


			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="3" align="center">
				<input type="submit" name="Aceptar" value="Guardar" class="boton"
				<cfif instancia.rechazado EQ 1>
					onClick="if (!confirm('El requisito ya ha sido rechazado, ¿desea cambiar su estado a completado?')) {return false;}"
				</cfif>
				>
				<cfif instancia.rechazado EQ 0>
					<input type="submit" name="Rechazar" value="Rechazar" class="boton"
					<cfif instancia.completado EQ 1>
					  onClick="if (!confirm('El requisito ya ha sido completado, ¿desea cambiar su estado a rechazado?')) return false;"
					</cfif>
					>
				</cfif>
			</td></tr>
		</cfoutput>
		
		<!---
		<cfif instancia.completado eq 1>
			<tr><td colspan="3"><font color="#FF0000">* Este requisito tiene estado Cumplido, no puede ser modificado</font></td></tr>	
		</cfif>	
		--->
	</table>
	<!---  ---></cfsavecontent>
</cfif>

<script language="javascript1.2" type="text/javascript">

	function popUp(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function vistaRequisito(registro,tipo,vista,persona,tramite,requisito) {
			var params ='';
			params = "?id_registro="+registro+"&id_tipo="+tipo+"&id_vistapopup="+vista+"&id_persona="+persona+"&id_tramite="+tramite+"&id_requisito="+requisito;
			popUp("/cfmx/home/tramites/vistas/vistasind-popup.cfm"+params,100,250,800,600);
		}

</script>