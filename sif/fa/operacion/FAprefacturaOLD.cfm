<!--- Sentencias para mantener el filtro de la Lista --->
<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset Form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.EstatusPF") and not isdefined("form.EstatusPF") and url.EstatusPF NEQ -1>
	<cfset Form.EstatusPF = url.EstatusPF>
</cfif>
<cfif isdefined("url.PFdocumento") and not isdefined("form.PFdocumento")>
	<cfset Form.PFdocumento = url.PFdocumento>
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfset Form.Mcodigo = url.Mcodigo>
</cfif>
<cfif isdefined("url.PFTcodigo") and not isdefined("form.PFTcodigo")>
	<cfabort showerror="MIRA">
	<cfset Form.PFTcodigo = url.PFTcodigo>
</cfif>
<cfif isdefined("url.Ocodigo") and not isdefined("form.Ocodigo")>
	<cfset Form.Ocodigo = url.Ocodigo>
</cfif>
<cfparam name="Navegacion" default="">
<cfparam name="Registros" default="20">
<!--- NAVEGACION --->
<cfif isdefined("Form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfset Navegacion = Navegacion & "SNcodigo=#Form.SNcodigo#&">
</cfif>
<cfif isdefined("Form.EstatusPF") and form.EstatusPF NEQ -1>
	<cfset Navegacion = Navegacion & "EstatusPF=#Form.EstatusPF#&">
</cfif>
<cfif isdefined("url.PFdocumento") and not isdefined("form.PFdocumento")>
	<cfset Form.PFdocumento = url.PFdocumento>
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfset Navegacion = Navegacion & "Mcodigo=#Form.Mcodigo#&">
</cfif>
<cfif isdefined("url.PFTcodigo") and not isdefined("form.PFTcodigo")>
	<cfset Navegacion = Navegacion & "PFTcodigo=#Form.PFTcodigo#&">
</cfif>
<cfif isdefined("url.Ocodigo") and not isdefined("form.Ocodigo")>
	<cfset Navegacion = Navegacion & "Ocodigo=#Form.Ocodigo#&">
</cfif>

<cf_templateheader title="Facturación">
	<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo=" Registro de Prefacturas">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<cfinclude template="../../portlets/pNavegacion.cfm">
				</td>
			</tr>
			<tr align="center">
				<td  valign="top">
					<cfif isdefined("form.SNDirec") and form.SNDirec EQ "valor">
                        <cfquery name="rsForm" datasource="#session.DSN#">
                        	Select 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pfdocumento#"> as PFdocumento,
								<cfif isdefined("form.ocodigo") and form.ocodigo NEQ ""> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ocodigo#"> as Ocodigo, </cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pftcodigo#"> as PFTcodigo, 
								<cfif isdefined("form.descuento") and form.descuento NEQ ""> <cfqueryparam cfsqltype="cf_sql_money" value="#form.Descuento#"> as Descuento </cfif>, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.observaciones#"> as Observaciones, 
								<cfif isdefined("form.fechacot") and len(trim("form.fechacot"))> <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.fechacot,'dd/mm/yyyy')#"> as FechaCot </cfif>,
					            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.numordencompra#"> as NumOrdenCompra
	                    </cfquery>
                        <cfinclude template="FAprefactura-form.cfm">
					<cfelseif (isdefined("Form.IDpreFactura") and len(trim(form.IDpreFactura))) or (isdefined("Form.btnNuevo"))>
						<cfinclude template="FAprefactura-form.cfm">
					<cfelse>
						<!--- Filtro para la lista --->
						<cfinclude template="FAprefactura-filtro.cfm">
						<cfquery name="rsPF" datasource="#session.dsn#">
							Select 
									IDpreFactura, SNnombre,fac.SNcodigo,
                                    PFdocumento,
									case Estatus
										when 'P' then 'Pendiente'
										when 'E' then 'Estimada'
                                        when 'A' then 'Anulada'
                                        when 'T' then 'Terminada'
                                        when 'V' then 'Vencida'
									end Estatus,
                                    case Estatus
										when 'P' then 0
										when 'E' then 0
                                        when 'A' then IDprefactura
                                        when 'T' then IDprefactura
                                        when 'V' then IDprefactura
									end as inactiva,
									Estatus as estado,
                                    m.Mnombre as Moneda,
                                    pf.PFTdescripcion as Transaccion,
                                    o.Odescripcion
							from FAPreFacturaE fac
								inner join SNegocios sn
								on fac.Ecodigo = sn.Ecodigo and sn.SNcodigo=fac.SNcodigo
                                inner join Monedas m
                                on fac.Ecodigo = m.Ecodigo and fac.Mcodigo = m.Mcodigo
                                inner join FAPFTransacciones pf
                                on fac.Ecodigo = pf.Ecodigo and fac.PFTcodigo = pf.PFTcodigo
                                inner join Oficinas o
                                on o.Ecodigo = fac.Ecodigo and o.Ocodigo = fac.Ocodigo
							where fac.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                            	and Estatus in ('P','E')
								<!---and Estatus in ('P','E')--->
								<cfif isdefined('form.EstatusPF') and len(trim(form.EstatusPF)) and form.EstatusPF NEQ '-1'>
									and Estatus=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EstatusPF#">
								</cfif>
								<cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo))>
									and fac.SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
								</cfif>
								<cfif isdefined('form.PFdocumento') and len(trim(form.PFdocumento)) and form.PFdocumento NEQ "">
									and PFdocumento like '%' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PFdocumento#"> + '%'
								</cfif>	
                                <cfif isdefined('form.Mcodigo') and len(trim(form.Mcodigo)) and form.Mcodigo NEQ '-1'>
									and fac.Mcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mcodigo#">
								</cfif>	
                                <cfif isdefined('form.PFTcodigo') and len(trim(form.PFTcodigo)) and form.PFTcodigo NEQ '-1'>
									and fac.PFTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PFTcodigo#">
								</cfif>	
                                <cfif isdefined('form.Ocodigo') and len(trim(form.Ocodigo)) and form.Ocodigo NEQ '-1'>
									and fac.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
								</cfif>	
                                Order by SNnombre
						</cfquery>
						
						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsPF#"/>
								<cfinvokeargument name="desplegar" value="PFdocumento, Odescripcion, Estatus,Moneda,Transaccion"/>
								<cfinvokeargument name="etiquetas" value="Pre-Factura, Oficina, Estatus, Moneda, Transacción"/>
								<cfinvokeargument name="formatos" value="S, S, S, S, S"/>
                                <cfinvokeargument name="cortes" value="SNnombre"/>
								<cfinvokeargument name="align" value="left, left, left, left, left"/>
								<cfinvokeargument name="ajustar" value="N, N, N, N, N"/>
								<cfinvokeargument name="irA" value="FAprefactura.cfm"/>
								<cfinvokeargument name="keys" value="IDpreFactura"/>
								<cfinvokeargument name="checkboxes" value="S"/>
								<cfinvokeargument name="botones" value="Nuevo,Aplicar_Factura,Aplicar_Estimado,Anular"/>
								<cfinvokeargument name="formName" value="frListaPF"/>
								<cfinvokeargument name="showemptylistmsg" value="true"/>
                                <cfinvokeargument name="inactivecol" value="inactiva"/>
                                <cfinvokeargument name="MaxRows" value="#Registros#"/>
			                    <cfinvokeargument name="Navegacion" value="#Navegacion#"/>
						</cfinvoke>
					</cfif>
				</td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	function funcNuevo(){	
	}
	// Aplicar
	function algunoMarcado(f){
		var aplica = false;
		if (document.frListaPF.chk) {
			if (document.frListaPF.chk.value) {
				aplica = document.frListaPF.chk.checked;
			}else{
				for (var i=0; i<document.frListaPF.chk.length; i++) {
					if (document.frListaPF.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			if (f == 'A')
			return (confirm("¿Está seguro de que desea aplicar los Documentos seleccionados?"));
			else 
			return (confirm("¿Está seguro de que desea ANULAR los Documentos seleccionados?"));
		} else {
			if (f == 'A')
			alert('Debe seleccionar al menos un documento antes de Aplicar');
			else
			alert('Debe seleccionar al menos un documento antes de Anular');
			return false;
		}
	}
	function funcAplicar() {
		if (algunoMarcado())
			document.frListaPF.action = "FAprefactura-sql.cfm";
		else
			return false;
	}
	function funcAplicar_Factura() {
		if (algunoMarcado('A')) 
			document.frListaPF.action = "FAprefactura-sql.cfm";
		else
			return false;
	}	
	function funcAplicar_Estimado() {
		if (algunoMarcado('A')) 
			document.frListaPF.action = "FAprefactura-sql.cfm";
		else
			return false;
	}		
	function funcAnular() {
		if (algunoMarcado('X')) 
			document.frListaPF.action = "FAprefactura-sql.cfm";
		else
			return false;
	}		
</script>
