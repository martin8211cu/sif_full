
<!--- Mostrar Paquetes --->
<cfif ExisteCuenta>

	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="plazoLogines">	<!---Consulta el plazo de vencimiento en dias para los logines que estan retirados--->
		<cfinvokeargument name="Pcodigo" value="40">
	</cfinvoke>
		
	  <cfquery name="rsReproProductos" datasource="#session.DSN#">
		select a.Contratoid, b.*, 
			   (select sum(SVcantidad) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = 'MAIL' and x.Habilitado = 1) as CantidadCorreos
		from ISBproducto a
			inner join ISBpaquete b
				on b.PQcodigo = a.PQcodigo
				and b.Habilitado=1
			inner join ISBcuenta c
				on c.CTid = a.CTid
				and c.Habilitado=1
				and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cli#">
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
		and a.CTcondicion not in ('C','0','X') 				<!--- Mientras el producto no esté en captura, pendiente de documentación y/o rechazado --->
		and (select count(1) 								<!---significa que al menos debe haber un servicio retirado que no este vencido---> 
				from ISBlogin z
				where z.Contratoid = a.Contratoid
				and z.Habilitado=2							<!---significa que al menos debe haber un servicio retirado que no este vencido---> 
				<!---and datediff( day, z.LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">--->
			) > 0
		and (	(select count(1) from ISBproducto x 
				where x.CTid = a.CTid
				and x.Contratoid = a.Contratoid
				and x.CTcondicion not in ('C','0','X') 
				and x.MRid is not null						<!---significa que los productos deben estar en estado retirado--->
				and x.CNfechaRetiro is not null)>0
				or 
				(select count(1) 
				from ISBproducto x
					inner join ISBlogin z
					on z.Contratoid=x.Contratoid
					and z.Habilitado=2						<!---significa que los logines deben estar en  habilitado=2, con borrado logico---> 
					<!---and datediff( day, z.LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">--->
				where x.CTid = a.CTid
				and x.Contratoid = a.Contratoid
				and x.CTcondicion not in ('C','0','X')) >0 		
			)
		<!---and a.MRid is not null							<!---significa que los productos deben estar en estado retirado--->
		and a.CNfechaRetiro is not null--->
		order by a.Contratoid
	  </cfquery>
	
	<cfoutput>
		
		<cf_web_portlet_start  tipo="box" border="true" skin="#Session.Preferences.Skin#" tituloalign="left" titulo="Productos">
			<script language="javascript" type="text/javascript">
				function goPage4(f, pkg_rep) {
					f.pkg_rep.value = pkg_rep;
					f.submit();
				}
			</script>
			
			<form name="formReproOpt" action="#CurrentPage#" method="get" style="margin: 0;">
				<cfinclude template="gestion-hiddens.cfm">
				<table border="0" cellpadding="2" cellspacing="0" width="100%">
				  
					<!--- 1 --->
					<cfloop query="rsReproProductos">  
						  <tr>
							<td width="1%" align="right">
							  <cfif Form.pkg_rep EQ  rsReproProductos.Contratoid>
								<img src="/cfmx/saci/images/addressGo.gif" border="0">
							  <cfelse>
								&nbsp;
							  </cfif>
							</td>
							<td>
								<a href="javascript: goPage4(document.formReproOpt,#rsReproProductos.Contratoid#);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
									<cfif Form.pkg_rep EQ rsReproProductos.Contratoid><strong></cfif>#rsReproProductos.PQnombre#<cfif Form.pkg_rep EQ  rsReproProductos.Contratoid></strong></cfif>
								</a>
							</td>
						  </tr>
					</cfloop>
		
				</table>
			</form>

		<cf_web_portlet_end>  
	</cfoutput>
</cfif>
