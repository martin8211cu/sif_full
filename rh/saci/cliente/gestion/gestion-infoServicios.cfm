<cfif ExisteInfoServ>
	<!--- Verifica si el paquete requiere telefonos --->
	<cfquery name="rsPaquetes" datasource="#session.DSN#">
		Select 
			paq.PQdescripcion
			, coalesce(paq.PQtarifaBasica,-1) as PQtarifaBasica
			, coalesce(paq.PQhorasBasica,-1) as PQhorasBasica
			, coalesce(paq.PQprecioExc,-1) as PQprecioExc
			, (select SVcantidad from ISBservicio a where a.PQcodigo = paq.PQcodigo and TScodigo = 'MAIL')-1 as  SVcantidad
			, coalesce(paq.PQmailQuota,-1) as PQmailQuota	
		
		from ISBpaquete paq
			
		<cfif isdefined('form.AGid')>	
			inner join ISBagenteOferta o
				on paq.PQcodigo = o.PQcodigo
				and o.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AGid#"> 	
		</cfif>
		where paq.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and paq.Habilitado = 1
			<cfif isdefined('desplTodos') and desplTodos EQ 1>
				and PQautogestion = 0			
			<cfelse>
				and PQautogestion = 1
			</cfif>
		order by paq.PQdescripcion
	</cfquery>
	
	<table  width="100%" cellpadding="2" cellspacing="0" border="0">
		<tr class="areaFiltro">
		  	<td><strong>Paquete</strong></td>
		  	<td align="center"><strong>Tarifa B&aacute;sica</strong></td>			
		  	<td align="center"><strong>Derecho Horas Mensuales</strong></td>			
			<td align="center"><strong>Costo Adicional por Hora</strong></td>			
			<td align="center"><strong>Cantidad de Correos</strong></td>						
			<td align="center"><strong>Quota Mail</strong></td>						
	  	</tr>
		<cfif isdefined('rsPaquetes') and rsPaquetes.recordCount GT 0>
			<cfoutput query="rsPaquetes">
				<tr>
				  	<td style="border-bottom:1px solid ##CCCCCC;">#rsPaquetes.PQdescripcion#</td>
				  	<td align="center" style="border-bottom:1px solid ##CCCCCC;">
				  		<cfif rsPaquetes.PQtarifaBasica EQ -1>
							&nbsp;
				  		<cfelse>
							#rsPaquetes.PQtarifaBasica#
				  		</cfif>
					</td>
				  	<td align="center" style="border-bottom:1px solid ##CCCCCC;">
				  		<cfif rsPaquetes.PQhorasBasica EQ -1>
							&nbsp;
				  		<cfelse>
							#rsPaquetes.PQhorasBasica#
				  		</cfif>
					</td>
					<td align="center" style="border-bottom:1px solid ##CCCCCC;">
				  		<cfif rsPaquetes.PQprecioExc EQ -1>
							&nbsp;
				  		<cfelse>
							#LsCurrencyFormat(rsPaquetes.PQprecioExc,"none")#
				  		</cfif>
					</td>
					<td align="center" style="border-bottom:1px solid ##CCCCCC;">
						#rsPaquetes.SVcantidad#
					</td>							
					<td align="center" style="border-bottom:1px solid ##CCCCCC;">
				  		<cfif rsPaquetes.PQmailQuota EQ -1>
							&nbsp;
				  		<cfelse>
							#LsCurrencyFormat(rsPaquetes.PQmailQuota,"none")#
				  		</cfif>
					</td>					
				</tr>			
			</cfoutput>
		</cfif>
	</table>
</cfif>