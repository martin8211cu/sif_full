
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
				cam.valor,
				cam.valor_ref,
				cam.id_registro
			<cfelse>
				null as valor,
				null as valor_ref,
				null as id_registro
			</cfif>

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
</cfquery>

<cfset datos_var = ''>
<cfset popup = 0>
<cfif datorequisito.RecordCount>
	<!--- ---><cfsavecontent variable="datos_var"> 
		<cfoutput query="datorequisito">
			<!---<input type="hidden" name="id_campo" value="#datorequisito.id_campo#">--->
			<input type="hidden" name="id_requisito_#datorequisito.id_requisito#_#datorequisito.id_campo#" value="#datorequisito.id_requisito#">
			<cfif listfind(requisitos,  datorequisito.id_requisito) eq 0>
				<cfset requisitos = listappend(requisitos, datorequisito.id_requisito ) >
			</cfif>
			<cfif listfind(campos,  datorequisito.id_campo) eq 0>
				<cfset campos = listappend(campos, datorequisito.id_campo ) >
			</cfif>
		</cfoutput>
	<table width="480" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid black;background-color:#ededed ">
		<cfoutput query="datorequisito">
			<tr>
			<td width="1%" nowrap>
				<label for="dato_#datorequisito.id_campo#">
				<strong>#datorequisito.nombre_campo#</strong></label>
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
						 valueid="#datorequisito.valor_ref#"
						 id_tipocampo="#id_tipocampo#"
						 form="form4">	
			</td>
			<td align="right" width="16">
				<cfif isdefined('popup') and popup EQ 0 and datorequisito.es_vistapopup>
					<a href="javascript: vistaRequisito('#id_registro#','#id_tipo#','#id_vistapopup#','#instancia.id_persona#','#url.id_tramite#','#datorequisito.id_requisito#');">
				<img alt="Ver datos de la Vista" 
					src="../../images/popup.gif" border="0"></a>
				<cfset popup = 1>
				<cfelse>&nbsp;
				</cfif>
			</td>
			</tr>
		</cfoutput>
		
		<tr><td colspan="3">
			<cfoutput>
			<input type="checkbox" name="completado_#instancia.id_requisito#" id="completado_#instancia.id_requisito#" value="1" <cfif instancia.completado>checked</cfif> >
			<label for="completado_#instancia.id_requisito#">
			 <strong>Marcar el requisito como completado</strong></label>
			 </cfoutput>
			 </td></tr>
			<cfoutput><tr><td colspan="3">#tiene_cita#</td></tr></cfoutput>
			<cfoutput><tr><td colspan="3">#tiene_conexion#</td></tr></cfoutput>
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
			popUp("/cfmx/home/tramites/vistas/vistasind-popup.cfm"+params,0,15,1050,800);
		}

</script>