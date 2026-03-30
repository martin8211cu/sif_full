<cfinclude template="catinit.cfm">
<cfquery datasource="#session.dsn#" name="rsCompProd">
	select ar.Aid,ar.Ecodigo,Adescripcion, Valor,CDdescripcion, lp.DLprecio, m.Miso4217
	from Articulos ar 
		left join ClasificacionesDato cd
		    on cd.Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
		left join ArticulosValor av
			on av.CDcodigo = cd.CDcodigo
			and av.Aid = ar.Aid
		left join DListaPrecios lp
			on lp.LPid = #session.lista_precios#
			and lp.Aid = ar.Aid
			and lp.Ecodigo = ar.Ecodigo
		left join Monedas m
			on m.Miso4217 = lp.moneda
			and m.Ecodigo = lp.Ecodigo
	where  ar.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined('url.ckCompa') and url.ckCompa NEQ ''>
			and ar.Aid in (
					<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ckCompa#">			
					)
		</cfif>
	order by Upper(CDdescripcion), Upper(Adescripcion)

</cfquery>

<cf_templatecss>
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">Comparativo de Productos</cf_templatearea>
<cf_templatearea name="body">
<cfinclude template="estilo.cfm">
<cfinclude template="catpath.cfm">
	<cfif isdefined('rsCompProd') and rsCompProd.recordCount GT 0>
		<table width="100" border="0" cellpadding="2" cellspacing="2">
		<cfset xx=0>
			<cfoutput query="rsCompProd" group="CDdescripcion">
				<cfif xx is 0>
					<cfif ListLen(url.ckCompa,',') GT 2>
					  <tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>						
						<cfset cantArt = 0>
						<cfoutput>
							<td width="125" align="center" valign="middle">
								<a href="comparacionProd.cfm?cat=#url.cat#&amp;ckCompa=#ListDeleteAt(url.ckCompa,ListFind(url.ckCompa,Aid))#">
									<img border="0"  src="images/btn_quitar.gif" alt="Agregar este articulo al carrito de compras">
								</a>
							</td>
						</cfoutput>
					  </tr>				
					</cfif>					  
					 <cfset descrCat = "Articulos">
					 <cfif isdefined('catpath_query')>
						 <cfloop query="catpath_query" startrow="#catpath_query.recordCount#">
								<cfset descrCat = Cdescripcion>
						 </cfloop>					 
					 </cfif>



					  <tr>
						<td width="108" nowrap align="center" valign="middle">
							<a href="catview.cfm?cat=#url.cat#" class="catview_link">Ver todos los #descrCat#</a>						
						</td>
						<td width="38" nowrap>&nbsp;</td>						
						<cfoutput>
							<td width="125" align="center" valign="middle">
								<a href="prodview.cfm?cat=#HTMLEditFormat(url.cat)#&amp;prod=#Aid#">
								<img src="producto_img.cfm?tid=#session.Ecodigo#&amp;id=#Aid#&sz=sm" height="60" border="0">							
								</a>
							</td>
						</cfoutput>
					  </tr>
					  <tr>
						<td width="108" nowrap align="center" valign="middle">&nbsp;
							
						</td>
						<td width="38" nowrap>&nbsp;</td>						
						<cfoutput>
							<td width="125" align="center" valign="middle">
								#Miso4217# #NumberFormat(DLprecio,',0.00')#
							</td>
						</cfoutput>
					  </tr>
					  
					  <tr>
						<td width="108" nowrap>&nbsp;</td>
						<td width="38" nowrap>&nbsp;</td>						
						<cfoutput>
						  <td width="125" align="center" valign="middle">
							<!--- <input name="agregar" type="image" id="agregar" value="Agregar" src="images/btn_agregar.gif" > --->
							<a href="producto_go.cfm?prod=#Aid#&amp;#url.cat#">
								<img border="0" src="images/btn_agregar.gif" width="140" height="16" alt="Agregar este articulo al carrito de compras"> 							
							</a>
						  </td>
						</cfoutput>
					  </tr>					  
					  <tr>			  
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>						
						<cfoutput>
						<td><strong>#HTMLEditFormat(Adescripcion)#</strong></td>
						</cfoutput>
					  </tr>
					  <cfset xx=1>
			  </cfif>
			  
			  <cfset LvarListaCarac = (CurrentRow MOD 2)>			  
			  <tr class=<cfif LvarListaCarac>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="<cfif NOT LvarListaCarac>LvarListaNonColor = style.backgroundColor;</cfif>style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor=<cfif CurrentRow MOD 2>'##FFFFFF'<cfelse>LvarListaNonColor</cfif>;">
				<td nowrap><strong>#HTMLEditFormat(CDdescripcion)#</strong></td>
				<td nowrap>&nbsp;</td>				
				<cfoutput>
					<td valign="top">#HTMLEditFormat(Valor)#</td>
				</cfoutput>
			  </tr>
			</cfoutput>
	  </table>
	</cfif>
</cf_templatearea>
</cf_template>
