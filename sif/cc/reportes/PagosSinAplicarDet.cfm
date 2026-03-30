<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset MSG_ErrGen = t.Translate('MSG_ErrGen','Se han generado mas de 5000 registros para este reporte.','DocumentosSinAplicarRes.xml')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfif isdefined("url.Generar")>
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select 	
				a.Pusuario,
				'Pago' as Tipo,
				a.Pcodigo,  
				a.Pfecha, 
				a.CCTcodigo,
				a.Ptotal  as Ptotal,
				coalesce((select sum(Anti.NC_total)
					from APagosCxC Anti 
				 where Anti.Ecodigo = a.Ecodigo 
				   and Anti.CCTcodigo = a.CCTcodigo 
				   and Anti.Pcodigo = a.Pcodigo), 0.00)  as NC_total,
				coalesce(rtrim(a.Preferencia), 'N/A') as Preferencia,
				a.Ptipocambio,
				coalesce(e.Ddocumento, ' -- ') as Ddocumento,				
				coalesce(c.Cdescripcion, ' -- ') as Cdescripcion, 
				d.Oficodigo,
				coalesce(e.Doc_CCTcodigo, ' ') as Doc_CCTcodigo,
				coalesce(e.DPmonto, 0.00) as DPmonto,
				coalesce(e.DPtotal,  
							     (select sum(Anti.NC_total)
									 from APagosCxC Anti 
				 					where Anti.Ecodigo = a.Ecodigo 
				   					  and Anti.CCTcodigo = a.CCTcodigo 
				                      and Anti.Pcodigo = a.Pcodigo), 0.00) as DPtotal,
				g.Edescripcion,
				f.Mnombre,
				b.SNnombre, 
				b.SNnumero,
				b.SNidentificacion,
				h.Dfecha
		 from Pagos a
			inner join SNegocios b
				on b.Ecodigo = a.Ecodigo
				and b.SNcodigo = a.SNcodigo
			inner join Oficinas d
				on d.Ecodigo =a.Ecodigo
				and d.Ocodigo = a.Ocodigo
			inner join Monedas f
				on f.Ecodigo = a.Ecodigo
				and f.Mcodigo = a.Mcodigo
			inner join Empresas g
				on g.Ecodigo = a.Ecodigo

			inner join DPagos e
				on e.CCTcodigo = a.CCTcodigo 
				and e.Pcodigo = a.Pcodigo
				and e.Ecodigo = a.Ecodigo
			inner join CContables c
				 on c.Ecodigo = e.Ecodigo
				and c.Ccuenta = e.Ccuenta 
			inner join Documentos h
				 on h.Ecodigo = e.Ecodigo 
				and h.Ddocumento = e.Ddocumento
				and h.CCTcodigo = e.Doc_CCTcodigo 

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<!--- Socio de negocios --->
			<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
				<cfif url.SNnumero gt SNnumerob2><!--- si el primero es mayor que el segundo. --->
						and b.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#"> 
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
				<cfelse>
						and b.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#"> 
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
				</cfif>											
			<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
				and b.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#"> 
			<cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
				and b.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
			</cfif>
			<!--- Tipo de transacción --->
			<cfif isdefined("url.Transaccion") and len(trim(url.Transaccion)) and isdefined("url.Transaccion2") and len(trim(url.Transaccion2))>
				<cfif url.Transaccion gt url.Transaccion2>
					and a.CCTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#"> 
						and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
				<cfelse>
					and a.CCTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
						and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
				</cfif>
			<cfelseif isdefined("url.Transaccion") and len(trim(url.Transaccion))>
				and a.CCTcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
			<cfelseif isdefined("url.Transaccion2") and len(trim(url.Transaccion2))>
				and a.CCTcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
			</cfif>

			<!--- Fechas Desde / Hasta --->
			 <cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				<cfif datecompare(url.fechaDes, url.fechaHas) eq -1> 
					and a.Pfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> 
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 1>
					and a.Pfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
				<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 0>
					and a.Pfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				</cfif>
			<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				and a.Pfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
			<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				and a.Pfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
			</cfif>
			<!--- Monedas Inicial / Final --->
			<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and isdefined("url.Moneda2") and len(trim(url.Moneda2))>
				<cfif url.Moneda gt Moneda2><!--- si el primero es mayor que el segundo. --->
						and f.Mcodigo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#"> 
											and <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#">
				<cfelse>
						and f.Mcodigo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
											and <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#">
				</cfif>											
			<cfelseif isdefined("url.Moneda") and len(trim(url.Moneda))>
				and f.Mcodigo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
			<cfelseif isdefined("url.Moneda2") and len(trim(url.Moneda2))>
				and f.Mcodigo <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#">
			</cfif>
			<!--- Oficina Inicial / Final --->
			<cfif isdefined("url.Oficodigo") and len(trim(url.Oficodigo)) and isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
				<cfif url.Oficodigo gt Oficodigo2><!--- si el primero es mayor que el segundo. --->
						and d.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#"> 
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#">
				<cfelse>
						and d.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> 
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
				</cfif>											
			<cfelseif isdefined("url.Oficodigo") and len(trim(url.Oficodigo))>
				and d.Oficodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> 
			<cfelseif isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
				and d.Oficodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
			</cfif>
			
			<!--- USUARIO --->
			<cfif isdefined("url.usuario") and len(trim(url.usuario)) and url.usuario neq -1>
				and a.Pusuario = <cfqueryparam cfsqltype="cf_sql_char" value="#url.usuario#"> 
			</cfif>
			
<!--- ******************************************************************************************************** --->

		union

			select 	
					a.Pusuario,
					'Anticipo' as Tipo,
					Anti.Pcodigo,  
					a.Pfecha, 
					Anti.CCTcodigo,
					a.Ptotal  as Ptotal,
					coalesce (Anti.NC_total, 0.00) as NC_total,
					coalesce(rtrim(a.Preferencia), 'N/A') as Preferencia,
					a.Ptipocambio,
					coalesce(Anti.NC_Ddocumento, ' -- ') as Ddocumento,				
					coalesce(c.Cdescripcion, ' -- ') as Cdescripcion, 
					d.Oficodigo,
					coalesce(Anti.NC_CCTcodigo, ' ') as Doc_CCTcodigo,
					coalesce(Anti.NC_total, 0.00) as Monto,
					 0, <!--- coalesce(e.DPtotal,  a.NC_total, 0.00) as DPtotal, --->
					g.Edescripcion,
					f.Mnombre,
					b.SNnombre, 
					b.SNnumero,
					b.SNidentificacion,
					Anti.NC_fecha
			 from Pagos a
			 	inner join APagosCxC Anti
					on Anti.Ecodigo = a.Ecodigo
					and Anti.CCTcodigo  = a.CCTcodigo
					and Anti.Pcodigo = a.Pcodigo
				inner join SNegocios b
					on b.Ecodigo = a.Ecodigo
					and b.SNcodigo = a.SNcodigo
				inner join Oficinas d
					on d.Ecodigo =a.Ecodigo
					and d.Ocodigo = a.Ocodigo
				inner join Monedas f
					on f.Ecodigo = a.Ecodigo
					and f.Mcodigo = a.Mcodigo
				inner join Empresas g
					on g.Ecodigo = a.Ecodigo
				inner join CContables c
					on c.Ccuenta = a.Ccuenta 
				
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Anti.NC_total <> 0
				<!--- Socio de negocios --->
				<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
					<cfif url.SNnumero gt SNnumerob2><!--- si el primero es mayor que el segundo. --->
							and b.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#"> 
												and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
					<cfelse>
							and b.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#"> 
												and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
					</cfif>											
				<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
					and b.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#"> 
				<cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
					and b.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
				</cfif>
				<!--- Tipo de transacción --->
				<cfif isdefined("url.Transaccion") and len(trim(url.Transaccion)) and isdefined("url.Transaccion2") and len(trim(url.Transaccion2))>
					<cfif url.Transaccion gt url.Transaccion2>
						and a.CCTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#"> 
							and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
					<cfelse>
						and a.CCTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
							and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
					</cfif>
				<cfelseif isdefined("url.Transaccion") and len(trim(url.Transaccion))>
					and a.CCTcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
				<cfelseif isdefined("url.Transaccion2") and len(trim(url.Transaccion2))>
					and a.CCTcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
				</cfif>
	
				<!--- Fechas Desde / Hasta --->
				 <cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>
					<cfif datecompare(url.fechaDes, url.fechaHas) eq -1> 
						and a.Pfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> 
							and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
					<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 1>
						and a.Pfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
							and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">

					<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 0>
						and a.Pfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
							and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
					</cfif>
				<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
					and a.Pfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
				<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
					and a.Pfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				</cfif>
				<!--- Monedas Inicial / Final --->
				<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and isdefined("url.Moneda2") and len(trim(url.Moneda2))>
					<cfif url.Moneda gt Moneda2><!--- si el primero es mayor que el segundo. --->
							and f.Mcodigo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#"> 
												and <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#">
					<cfelse>
							and f.Mcodigo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
												and <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#">
					</cfif>											
				<cfelseif isdefined("url.Moneda") and len(trim(url.Moneda))>
					and f.Mcodigo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
				<cfelseif isdefined("url.Moneda2") and len(trim(url.Moneda2))>
					and f.Mcodigo <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#">
				</cfif>
				<!--- Oficina Inicial / Final --->
				<cfif isdefined("url.Oficodigo") and len(trim(url.Oficodigo)) and isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
					<cfif url.Oficodigo gt Oficodigo2><!--- si el primero es mayor que el segundo. --->
							and d.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#"> 
												and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#">
					<cfelse>
							and d.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> 
												and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
					</cfif>											
				<cfelseif isdefined("url.Oficodigo") and len(trim(url.Oficodigo))>
					and d.Oficodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> 
				<cfelseif isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
					and d.Oficodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
				</cfif>
				
			<!--- USUARIO --->
			<cfif isdefined("url.usuario") and len(trim(url.usuario)) and url.usuario neq -1>
				and a.Pusuario = <cfqueryparam cfsqltype="cf_sql_char" value="#url.usuario#"> 
			</cfif>
			
		union
		
			select 
					a.Pusuario,
					'Otro' as Tipo,
					a.Pcodigo,  
					a.Pfecha, 
					a.CCTcodigo, 
					a.Ptotal  as Ptotal,
					0.00 as NC_total,
					coalesce(rtrim(a.Preferencia), 'N/A') as Preferencia,
					a.Ptipocambio,
					'*** DESBALANCE: ' as Ddocumento,
					' ' as Cdescripcion, 
					d.Oficodigo,
					' ' as Doc_CCTcodigo,
					(round(a.Ptotal - 
						(select coalesce(sum(Anti.NC_total),0.00) from APagosCxC Anti where Anti.Ecodigo = a.Ecodigo and Anti.CCTcodigo = a.CCTcodigo and Anti.Pcodigo = a.Pcodigo)-
					    (select coalesce(sum(d.DPtotal), 0.00) from DPagos d where d.Ecodigo = a.Ecodigo and d.CCTcodigo = a.CCTcodigo and d.Pcodigo = a.Pcodigo) ,2)) as Monto,
					0, 
					g.Edescripcion,
					f.Mnombre,
					b.SNnombre, 
					b.SNnumero,
					b.SNidentificacion,
					' ' 
			 from Pagos a
				inner join SNegocios b
					on b.Ecodigo = a.Ecodigo
					and b.SNcodigo = a.SNcodigo
				inner join Oficinas d
					on d.Ecodigo =a.Ecodigo
					and d.Ocodigo = a.Ocodigo
				inner join Monedas f
					on f.Ecodigo = a.Ecodigo
					and f.Mcodigo = a.Mcodigo
				inner join Empresas g
					on g.Ecodigo = a.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and round(a.Ptotal - 
			  (select coalesce(sum(Anti.NC_total),0.00) from APagosCxC Anti where Anti.Ecodigo = a.Ecodigo and Anti.CCTcodigo = a.CCTcodigo and Anti.Pcodigo = a.Pcodigo) - 
			  (select coalesce(sum(d.DPtotal), 0.00)    from DPagos d where d.Ecodigo = a.Ecodigo and d.CCTcodigo = a.CCTcodigo and d.Pcodigo = a.Pcodigo) ,2) <> 0
				
				<!--- Socio de negocios --->
				<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
					<cfif url.SNnumero gt SNnumerob2><!--- si el primero es mayor que el segundo. --->
							and b.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#"> 
												and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
					<cfelse>
							and b.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#"> 
												and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
					</cfif>											
				<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
					and b.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#"> 
				<cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
					and b.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
				</cfif>
				<!--- Tipo de transacción --->
				<cfif isdefined("url.Transaccion") and len(trim(url.Transaccion)) and isdefined("url.Transaccion2") and len(trim(url.Transaccion2))>
					<cfif url.Transaccion gt url.Transaccion2>
						and a.CCTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#"> 
							and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
					<cfelse>
						and a.CCTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
							and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
					</cfif>
				<cfelseif isdefined("url.Transaccion") and len(trim(url.Transaccion))>
					and a.CCTcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
				<cfelseif isdefined("url.Transaccion2") and len(trim(url.Transaccion2))>
					and a.CCTcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
				</cfif>
	
				<!--- Fechas Desde / Hasta --->
				 <cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>
					<cfif datecompare(url.fechaDes, url.fechaHas) eq -1> 
						and a.Pfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> 
							and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
					<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 1>
						and a.Pfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
							and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
					<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 0>
						and a.Pfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
							and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
					</cfif>
				<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
					and a.Pfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
				<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
					and a.Pfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				</cfif>
				<!--- Monedas Inicial / Final --->
				<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and isdefined("url.Moneda2") and len(trim(url.Moneda2))>
					<cfif url.Moneda gt Moneda2><!--- si el primero es mayor que el segundo. --->
							and f.Mcodigo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#"> 
												and <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#">
					<cfelse>
							and f.Mcodigo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
												and <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#">
					</cfif>											
				<cfelseif isdefined("url.Moneda") and len(trim(url.Moneda))>
					and f.Mcodigo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
				<cfelseif isdefined("url.Moneda2") and len(trim(url.Moneda2))>
					and f.Mcodigo <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#">
				</cfif>
				<!--- Oficina Inicial / Final --->
				<cfif isdefined("url.Oficodigo") and len(trim(url.Oficodigo)) and isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
					<cfif url.Oficodigo gt Oficodigo2><!--- si el primero es mayor que el segundo. --->
							and d.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#"> 
												and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#">
					<cfelse>
							and d.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> 
												and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
					</cfif>											
				<cfelseif isdefined("url.Oficodigo") and len(trim(url.Oficodigo))>
					and d.Oficodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> 
				<cfelseif isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
					and d.Oficodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
				</cfif>
				
			<!--- USUARIO --->
			<cfif isdefined("url.usuario") and len(trim(url.usuario)) and url.usuario neq -1>
				and a.Pusuario = <cfqueryparam cfsqltype="cf_sql_char" value="#url.usuario#"> 
			</cfif>

<!--- ******************************************************************************************************** --->	
		order by 16, 17, 4, 2, 1 desc, 12, 9
	</cfquery>
	
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
		<cf_errorCode	code = "50196" msg = "#MSG_ErrGen#">
		<cfabort>
	</cfif>
	
	<!--- Busca nombre del Socio de Negocios 1 --->
	<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<cfquery name="rsSNcodigo" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<!--- Busca nombre del Socio de Negocios 2 --->
	<cfif isdefined("url.SNcodigob2") and len(trim(url.SNcodigob2))>
		<cfquery name="rsSNcodigob2" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigob2#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<!--- Busca el nombre de la Oficina Inicial --->
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		<cfquery name="rsOficinaIni" datasource="#session.DSN#">
			select Ocodigo, Odescripcion
			from Oficinas
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
		</cfquery>
	</cfif>
	
	
	<!--- Busca el nombre de la Oficina Final --->
	<cfif isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
		<cfquery name="rsOficinaFin" datasource="#session.DSN#">
			select Ocodigo, Odescripcion
			from Oficinas
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo2#">
		</cfquery>
	</cfif>
	
	<!--- Busca el nombre de la moneda inicial --->
	<cfif isdefined("url.moneda")	and len(trim(url.moneda))>
		<cfquery name="rsMonedaIni" datasource="#session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.moneda#">
		</cfquery>
	</cfif>


	<!--- Busca el nombre de la moneda Final --->
	<cfif isdefined("url.moneda2")	and len(trim(url.moneda2))>
		<cfquery name="rsMonedaFin" datasource="#session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.moneda2#">
		</cfquery>
	</cfif>
	
	<!--- Busca el nombre de la Transacción Inicial --->	
	<cfquery name="rsTransaccion" datasource="#session.DSN#">
		select CCTdescripcion 
		from CCTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
		  and CCTtipo = '#url.tipo#' 
		  and coalesce(CCTpago,0) = 1
	</cfquery>
	
	<!--- Busca el nombre de la Transacción Final --->	
	<cfquery name="rsTransaccion2" datasource="#session.DSN#">
		select CCTdescripcion 
		from CCTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
		  and CCTtipo = '#url.tipo#' 
		  and coalesce(CCTpago,0) = 1
	</cfquery>
	
	
	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	</cfif>
    
<cfset Tit_PagosSAplDet = t.Translate('Tit_PagosSAplDet','Pagos sin Aplicar (Detallado)')>
<cfset LB_CodigoSocio = t.Translate('LB_CodigoSocio','Código del Socio')>
<cfset LB_TC = t.Translate('LB_TC','TC')>
<cfset LB_TotalSocio = t.Translate('LB_TotalSocio','Total Socio')>
<cfset LB_TotalMoneda = t.Translate('LB_TotalMoneda','Total Moneda')>

<cfset LB_Anticipo = t.Translate('LB_Anticipo','Anticipo','PagosSinAplicarRes.xml')>
<cfset LB_Hora = t.Translate('LB_Hora','Hora','DocumentosSinAplicarRes.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Moneda 		= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_SocioNegocio 	= t.Translate('LB_Socio_de_Negocios','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','DocumentosSinAplicarRes.xml')>
<cfset LB_Oficina = t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_Criterio = t.Translate('LB_Criterio','Criterios de Selección:','DocumentosSinAplicarRes.xml')>
<cfset LB_Fecha_Inicial = t.Translate('LB_Fecha_Inicial','Fecha Inicial','/sif/generales.xml')>
<cfset LB_Fecha_Final 	= t.Translate('LB_Fecha_Final','Fecha Final','/sif/generales.xml')>
<cfset LB_SocioNegocioI = t.Translate('LB_SocioNegocioI','Socio de Negocios Inicial')>
<cfset LB_SocioNegocioF = t.Translate('LB_SocioNegocioF','Socio de Negocios Final')>
<cfset LB_OficinaInicial = t.Translate('LB_OficinaInicial','Oficina Inicial')>
<cfset LB_OficinaFinal = t.Translate('LB_OficinaFinal','Oficina Final')>
<cfset LB_Fecha_Inicial = t.Translate('LB_Fecha_Inicial','Fecha Inicial','/sif/generales.xml')>
<cfset LB_Fecha_Final 	= t.Translate('LB_Fecha_Final','Fecha Final','/sif/generales.xml')>
<cfset LB_MonedaFinal = t.Translate('LB_MonedaFinal','Moneda Final')>
<cfset LB_MonedaInicial = t.Translate('LB_MonedaInicial','Moneda Inicial')>
<cfset LB_TransaccFinal = t.Translate('LB_TransaccFinal','Transacción Final')>
<cfset LB_TransaccInicial = t.Translate('LB_TransaccInicial','Transacción Inicial')>
	
	  <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.PagosSinAplicarDet"/>
	<cfelse>
	  <cfreport format="#formatos#" template= "PagosSinAplicarDet.cfr" query="rsReporte">	
	
		<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
			<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
		</cfif>
		<cfif isdefined("rsSNcodigob2") and rsSNcodigob2.recordcount gt 0>
			<cfreportparam name="SNcodigob2" value="#rsSNcodigob2.SNnombre#">
		</cfif>
		
		<cfif isdefined("rsOficinaIni") and rsOficinaIni.recordcount gt 0>
			<cfreportparam name="Oficina" value="#rsOficinaIni.Odescripcion#">
		</cfif>
		<cfif isdefined("rsOficinaFin") and rsOficinaFin.recordcount gt 0>
			<cfreportparam name="Oficina2" value="#rsOficinaFin.Odescripcion#">
		</cfif>

		<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
			<cfreportparam name="fechaDes" value="#url.fechaDes#">
		</cfif>		
		<cfif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
			<cfreportparam name="fechaHas" value="#url.fechaHas#">
		</cfif>		

		<cfif isdefined("rsMonedaIni") and rsMonedaIni.recordcount gt 0>
			<cfreportparam name="MonedaIni" value="#rsMonedaIni.Mnombre#">
		</cfif>		
		<cfif isdefined("rsMonedaFin") and rsMonedaFin.recordcount gt 0>
			<cfreportparam name="MonedaFin" value="#rsMonedaFin.Mnombre#">
		</cfif>		

		<cfif isdefined("rsTransaccion") and rsTransaccion.recordcount gt 0>
			<cfreportparam name="Transaccion" value="#rsTransaccion.CCTdescripcion#">
		</cfif>
		<cfif isdefined("rsTransaccion2") and rsTransaccion2.recordcount gt 0>
			<cfreportparam name="Transaccion2" value="#rsTransaccion2.CCTdescripcion#">
		</cfif>
		<cfif isdefined("url.usuario") and len(trim(url.usuario)) and url.usuario neq -1>
			<cfreportparam name="Usuario" value="#url.usuario#">
		<cfelse>
			<cfreportparam name="Usuario" value="#LB_Todos#">
		</cfif>
		<cfreportparam name="Tit_PagosSAplDet" value="#Tit_PagosSAplDet#">
		<cfreportparam name="LB_Fecha" value="#LB_Fecha#">
		<cfreportparam name="LB_Hora" value="#LB_Hora#">
		<cfreportparam name="LB_Moneda" value="#LB_Moneda#">
		<cfreportparam name="LB_SocioNegocio" value="#LB_SocioNegocio#">
		<cfreportparam name="LB_Documento" value="#LB_Documento#">
		<cfreportparam name="LB_Oficina" value="#LB_Oficina#">
		<cfreportparam name="LB_TC" value="#LB_TC#">
		<cfreportparam name="LB_Monto" value="#LB_Monto#">
		<cfreportparam name="LB_TotalSocio" value="#LB_TotalSocio#">
		<cfreportparam name="LB_TotalMoneda" value="#LB_TotalMoneda#">
		<cfreportparam name="LB_USUARIO" value="#LB_USUARIO#">
        <cfreportparam name="LB_Criterio" value="#LB_Criterio#">
        <cfreportparam name="LB_Fecha_Inicial" value="#LB_Fecha_Inicial#">
        <cfreportparam name="LB_Fecha_Final" 	value="#LB_Fecha_Final#">
        <cfreportparam name="LB_SocioNegocioI" 	value="#LB_SocioNegocioI#">
        <cfreportparam name="LB_SocioNegocioF" 	value="#LB_SocioNegocioF#">
        <cfreportparam name="LB_OficinaInicial" 	value="#LB_OficinaInicial#">
        <cfreportparam name="LB_OficinaFinal" 	value="#LB_OficinaFinal#">
        <cfreportparam name="LB_MonedaInicial" 	value="#LB_MonedaInicial#">
        <cfreportparam name="LB_MonedaFinal" 	value="#LB_MonedaFinal#">
        <cfreportparam name="LB_TransaccFinal" 	value="#LB_TransaccFinal#">
        <cfreportparam name="LB_TransaccInicial" 	value="#LB_TransaccInicial#">
	</cfreport>
	</cfif>
</cfif>