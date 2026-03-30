<cffunction name="fnAsignaquery" access="private" returntype="string">
<cfif isdefined ('variable') and variable eq 1 or variable eq 3>
	<cfset tipoReporte ="Aplicado">
<cfelse>
</cfif>
	<cfif not isdefined("resumido")>
		<cfsavecontent variable="rsTSApl">
			<cfoutput>
                select
                coalesce(b.CFcodigo, 'NA') as centroFuncional,
                b.CFdescripcion as centroFuncionalD,
                c.ACcodigodesc as categoria,
                coalesce(c.ACdescripcion,'NA') as categoriaD,
                d.ACcodigodesc as clase,
                coalesce(d.ACdescripcion,'NA') as claseD,
                e.AFMcodigo as marca,
                coalesce(e.AFMdescripcion,'NA') as marcaD,
                f.AFMMcodigo as modelo, 
                coalesce(f.AFMMdescripcion,'NA') as modeloD,
                coalesce(a.GATplaca,'NA') as placa,
                coalesce(a.GATdescripcion,'NA') as placaD,
                h.Cmayor as cuentaMayor,
                coalesce(h.CFformato,'NA') as cuentaFormato, 
                h.Ccuenta as cuenta,
                a.GATmonto as monto,
                a.AFRmotivo, a.GATvutil,
					 <!---
					 	MOTIVO DE MODIFICACION: Se realizaban MEJORAS con Aumento en el monto y no en la vida Util(Totalmente valido), el reporte lo colocaba ADQUISION.
						Actualmente si se realiza la adquisicion y mejora del mismo Activo el mismo dia, mentiria en la transaccion de Mejora.
						habria que considerar colocar un IdTrans en GATransacciones y GABTransacciones para no tener que asumirlo.
					 --->
                case when GATmonto < 0 then 'Retiro'
					 when (select count(1) 
					         from Activos 
							where Ecodigo = a.Ecodigo
							  and Aplaca = a.GATplaca 
							  and <cf_dbfunction name="to_date00" args="Afechaaltaadq">  < <cf_dbfunction name="to_date00" args="a.fechaalta"> ) > 0 then 'Mejora'
					else 'Adquisicion' end as Transaccion,
					 
                case GATestado 
                        when 0 then 'Incompleto' 
                        when 1 then 'Completo' 
                        when 2 then 'Conciliado' 
                        when 3 then 'Aplicado'
                    end
                as GATestadoD,
                ofi.Oficodigo,
                ofi.Odescripcion,
                a.GATfechainidep,
                a.GATfechainirev,
                a.Cconcepto as Asiento,
                a.Edocumento as Poliza,
                a.GATReferencia as Referencia
                
				<cfif isdefined ('variable') and variable eq 1 or variable eq 3>
                    from GABTransacciones a
                        left outer join CFuncional b
                            on b.CFid = a.CFid
                            and b.Ecodigo = a.Ecodigo
                        left outer join ACategoria c
                            on c.ACcodigo = a.ACcodigo
                            and c.Ecodigo = a.Ecodigo
                        left outer join AClasificacion d
                            on d.ACid = a.ACid
                            and d.ACcodigo = a.ACcodigo
                            and d.Ecodigo = a.Ecodigo
                        left outer join AFMarcas e
                            on e.AFMid = a.AFMid
                            and e.Ecodigo = a.Ecodigo
                        left outer join AFMModelos f
                            on f.AFMid = a.AFMid
                            and f.AFMMid = a.AFMMid
                            and f.Ecodigo = a.Ecodigo
                        left outer join AFClasificaciones g
                            on g.AFCcodigo = a.AFCcodigo
                            and g.Ecodigo = a.Ecodigo
                        left outer join CFinanciera h
                            on h.CFcuenta = a.CFcuenta
                            and h.Ecodigo = a.Ecodigo
                        left outer join Oficinas ofi
                            on  ofi.Ocodigo = a.Ocodigo
                            and ofi.Ecodigo = a.Ecodigo
                    <cfelse>
                        from GATransacciones a
                        left outer join CFuncional b
                            on b.CFid = a.CFid
                            and b.Ecodigo = a.Ecodigo
                        left outer join ACategoria c
                            on c.ACcodigo = a.ACcodigo
                            and c.Ecodigo = a.Ecodigo
                        left outer join AClasificacion d
                            on d.ACid = a.ACid
                            and d.ACcodigo = a.ACcodigo
                            and d.Ecodigo = a.Ecodigo
                        left outer join AFMarcas e
                            on e.AFMid = a.AFMid
                            and e.Ecodigo = a.Ecodigo
                        left outer join AFMModelos f
                            on f.AFMid = a.AFMid
                            and f.AFMMid = a.AFMMid
                            and f.Ecodigo = a.Ecodigo
                        left outer join AFClasificaciones g
                            on g.AFCcodigo = a.AFCcodigo
                            and g.Ecodigo = a.Ecodigo
                        left outer join CFinanciera h
                            on h.CFcuenta = a.CFcuenta
                            and h.Ecodigo = a.Ecodigo
                        left outer join Oficinas ofi
                            on ofi.Ocodigo = a.Ocodigo
                            and ofi.Ecodigo = a.Ecodigo
                    </cfif>
                    where a.Ecodigo      = #session.Ecodigo#
                        and a.GATperiodo = #form.periodo#
                        and a.GATmes     = #form.mes#		
                <cfif isDefined("form.concepto") and len(trim(form.concepto)) and form.concepto GTE 0>
                    and a.Cconcepto = #form.concepto#
                <cfelseif isDefined("form.concepto") and len(trim(form.concepto)) and form.concepto EQ -10>
                    and a.Cconcepto is null
                </cfif>
                <cfif isDefined("form.Edocumento") and len(trim(form.Edocumento)) and form.Edocumento GTE 0>
                    and a.Edocumento = #form.Edocumento#
                <cfelseif isDefined("form.Edocumento") and len(trim(form.Edocumento)) and form.Edocumento EQ -10>
                    and a.Edocumento is null
                </cfif>
                <cfif isDefined("form.estado") and form.estado neq "-1">
                    and a.GATestado = #form.estado#
                </cfif>
                
                <cfif isdefined ('variable') and variable eq 1>		
                    #LvarCondicion1#
                    <cfelseif variable eq 2>
                        #LvarCondicion2#
                    <cfelseif variable eq 3>
                        #LvarCondicion3#
                    <cfelse>
                </cfif>
            
                order by
                    centroFuncionalD,
                    categoriaD,
                    claseD,
                    cuentaFormato,
                    placa
						 
            </cfoutput>
		</cfsavecontent>
	<cfelse>
		<cfsavecontent variable="rsTSApl">
			<cfoutput>
                select 
                    a.GATdescripcion as placaD ,
                    h.CFformato as cuentaFormato,
                    case when AFRmotivo > 0 and AFRmotivo <> 0 then 'Retiro' when GATvutil > 0 and GATvutil <> 0 then 'Mejora' else 'Adquisicion' end as Transaccion,
                    case GATestado 
                            when 0 then 'Incompleto' 
                            when 1 then 'Completo' 
                            when 2 then 'Conciliado' 
                            when 3 then 'Aplicado'
                        end
                    as GATestadoD,
                    sum(a.GATmonto) as monto
                from GATransacciones a
                    left outer join CFuncional b
                        on b.CFid = a.CFid
                        and b.Ecodigo = a.Ecodigo
                    left outer join ACategoria c
                        on c.ACcodigo = a.ACcodigo
                        and c.Ecodigo = a.Ecodigo
                    left outer join AClasificacion d
                        on d.ACid = a.ACid
                        and d.ACcodigo = a.ACcodigo
                        and d.Ecodigo = a.Ecodigo
                    left outer join AFMarcas e
                        on e.AFMid = a.AFMid
                        and e.Ecodigo = a.Ecodigo
                    left outer join AFMModelos f
                        on f.AFMid = a.AFMid
                        and f.AFMMid = a.AFMMid
                        and f.Ecodigo = a.Ecodigo
                    left outer join AFClasificaciones g
                        on g.AFCcodigo = a.AFCcodigo
                        and g.Ecodigo = a.Ecodigo
                    left outer join CFinanciera h
                        on h.CFcuenta = a.CFcuenta
                        and h.Ecodigo = a.Ecodigo
                    left outer join Oficinas ofi
                        on ofi.Ocodigo = a.Ocodigo
                        and ofi.Ecodigo = a.Ecodigo
                where a.Ecodigo = #session.Ecodigo#
                and a.GATperiodo = #form.periodo#
                and a.GATmes     = #form.mes#
                group by   h.CFformato , a.GATdescripcion,a.AFRmotivo, a.GATvutil,GATestado
            </cfoutput>
		</cfsavecontent>           
	</cfif>
<cfreturn rsTSApl>
</cffunction>
