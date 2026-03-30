<!----============== TRADUCCION ===============---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Esta_seguro_de_que_desea_eliminar_el_componente_salarial"
	Default="¿Está seguro de que desea eliminar el componente salarial?"	
	returnvariable="MSG_EliminarComponente"/>
<script language="javascript" type="text/javascript">
	function EliminarComp(id) {
		<cfoutput>
		if (confirm('#MSG_EliminarComponente#')) {
			document.form1.RHDAlinea_del.value = id;
			document.form1.reloadPage.value = '1';
			return true;
		}
		</cfoutput>
		return false;
	}
</script>
<cfoutput>
	<input type="hidden" name="RHDAlinea_del" />
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
	  <tr>
		<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="LB_Componentes_Propuestos">Componentes Propuestos</cf_translate></div></td>
	  </tr>
	  <tr>
		<td>
			<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
				select coalesce(Pvalor,'0') as  Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Pcodigo = 1040
			</cfquery>
			
			
			<cfif isdefined("rsSumComponentesAccion.Total") and len(trim(rsSumComponentesAccion.Total))>
				<cfset vTotal = rsSumComponentesAccion.Total >
			<cfelse>
				<cfset vTotal = 0 >
			</cfif>
	
			<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
				<cfinvokeargument name="id" value="#rsAccion.RHAlinea#">
				<cfinvokeargument name="query" value="#rsComponentesAccion#">
				<cfinvokeargument name="totalComponentes" value="#vTotal#">
				<cfinvokeargument name="MostrarSalarioNominal" value="#rsMostrarSalarioNominal.Pvalor#">
				<cfinvokeargument name="Tiponomina" value="#Lvar_Tcodigo#">
				<cfinvokeargument name="sql" value="1">
				<cfinvokeargument name="readonly" value="#Len(Trim(rsAccion.Tcodigo)) EQ 0 or rsAccion.RHTccomp EQ 0 or not Lvar_Modifica#">
				<cfinvokeargument name="permiteAgregar" value="#Len(Trim(rsAccion.Tcodigo)) and Lvar_Modifica#">
				<cfinvokeargument name="negociado" value="#LvarNegociado#">
				<cfinvokeargument name="funcionEliminar" value="EliminarComp">
				<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
					<cfinvokeargument name="Ecodigo" value="#rsAccion.EcodigoRef#">
				</cfif>
			</cfinvoke>
			
		</td>
	  </tr>

			<!---**********************************************En caso del articulo 40*********************************************************--->
			<cfquery name="rsVerTAccion" datasource="#session.dsn#">
				select RHCatParcial 
					from RHTipoAccion 
				where RHTid=(select RHTid 
							from RHAcciones 
							where RHAlinea=#rsAccion.RHAlinea#)
			</cfquery>
			<cfif rsVerTAccion.RHCatParcial eq 1>
				<!---Para la aplicacion del articulo 40 se debe de averiguar el salario base de la categoria en la que estoy y el salario base de la categoria propuesta--->
				<!---Salario Base de la categoria actual--->
				<cfquery name="rsMonto" datasource="#session.dsn#">
 					select coalesce(RHMCmonto,0) as RHMCmonto from RHCategoriasPuesto p
					 inner join RHVigenciasTabla t
					 on t.RHTTid=p.RHTTid
					 inner join RHMontosCategoria m
					 on m.RHCid=p.RHCid
				 where p.RHCPlinea=(select min(RHCPlinea) from LineaTiempo 
								 	where DEid=(select DEid from RHAcciones where RHAlinea=#rsAccion.RHAlinea#))
				 and m.RHVTid=( 
								 select RHVTid from RHVigenciasTabla 
								 where 
								 (select DLfvigencia from RHAcciones where RHAlinea = #rsAccion.RHAlinea#) between RHVTfecharige and RHVTfechahasta
								 and RHTTid = (select RHTTid from RHCategoriasPuesto where RHCPlinea=(select min(RHCPlinea) from LineaTiempo
								 				 where DEid=(select DEid from RHAcciones where RHAlinea=#rsAccion.RHAlinea#)))
								 )
											
				</cfquery>
				<!---Salario Base de la categoria propuesta--->
				<cfquery name="rsMontoP" datasource="#session.dsn#">
					select coalesce(RHMCmonto,0) as RHMCmonto 
					from RHCategoriasPuesto p 
					inner join RHVigenciasTabla t 
					on t.RHTTid=p.RHTTid 
					inner join RHMontosCategoria m 
					on m.RHCid=p.RHCid 
					where p.RHCPlinea=(select RHCPlineaP from RHAcciones where RHAlinea=#rsAccion.RHAlinea#) 
					and m.RHVTid=( select RHVTid from RHVigenciasTabla 
											where (select DLfvigencia from RHAcciones where RHAlinea = #rsAccion.RHAlinea#) between RHVTfecharige and RHVTfechahasta 
										   and RHTTid = (select RHTTid from RHCategoriasPuesto where RHCPlinea=(select RHCPlineaP from RHAcciones 
										   				where RHAlinea=#rsAccion.RHAlinea#)) ) 			
				</cfquery>
				<cfif isdefined ('rsMontoP') and rsMontoP.recordcount gt 0>
					<cfset LvarMonto=rsMonto.RHMCmonto+abs(((rsMontoP.RHMCmonto-rsMonto.RHMCmonto)/2))>
					<cfset LvarMonto= LSNumberFormat(LvarMonto,",0.00")>
				</cfif>
				<tr>
	  				<td>
						<cfoutput><strong>Monto de Salario Base de Categor&iacute;a Propuesta: &nbsp;</strong><cfif isdefined ('rsMontoP') and rsMontoP.recordcount gt 0>#LSNumberFormat(rsMontoP.RHMCmonto,",0.00")#<cfelse>0.00</cfif></cfoutput>
					</td>
			 	</tr>
				<tr>
	  				<td>
						<strong>Monto de Salario Base con Art&iacute;culo 40: &nbsp;</strong><cfif isdefined ('rsMontoP') and rsMontoP.recordcount gt 0>#LvarMonto#<cfelse>0.00</cfif>
					</td>
			    </tr>
			</cfif>
		</table>
</cfoutput>