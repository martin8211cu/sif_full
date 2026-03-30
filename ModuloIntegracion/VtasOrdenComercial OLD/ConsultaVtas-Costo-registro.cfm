 <cf_templateheader title="Movimientos de Utilidad Bruta">
	
			
		<cfquery name = "RsIDSaldo" datasource="#Session.DSN#">
			select ID_Saldo
			from SaldosUtilidad
			where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
			and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.NMes#">
			and Orden_Comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Orden_Comercial#">
			and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clas_Venta#">
			and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Moneda#">
			group by ID_Saldo, Periodo, Mes, Orden_Comercial, Clas_Venta
		</cfquery>
		
		<cfset ID = '0'>
		<cfset IDi = ''>
		<cfif RsIDSaldo.recordcount GT 1>
			<cfloop query="RsIDSaldo">
				<cfif ID EQ 0>
					<cfset IDi = ID & ',' &  #RsIDSaldo.ID_Saldo#>					
					<cfset ID = IDi>
				<cfelse>
					<cfset ID = ID &',' &  #RsIDSaldo.ID_Saldo#>
				</cfif>
			</cfloop>
		<cfelseif RsIDSaldo.recordcount EQ 1>
			<cfset ID = #RsIDSaldo.ID_Saldo#>
		</cfif>
		
	
		<cfquery name = "RsRegCab" datasource="#Session.DSN#">
			select Periodo, case Mes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 	
		    4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 
            9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end as           
         	Mes, Orden_Comercial, case Clas_Venta when 'PRFC' then 'FACT' when 'PRNF' then 'NOFACT' end as Tipo_Documento,				            convert(varchar, convert(money,sum(Imp_Ingreso)),1) as Ingreso_Documento,
            convert(varchar,convert(money,sum(Imp_Ingreso_Actual)),1) as Ingreso_Actual,            		            convert(varchar,convert(money,sum(Imp_Costo)),1) as Costo_Documento,
            convert(varchar,convert(money,sum(Imp_Costo_Actual)),1) as Costo_Agregado  
			from SaldosUtilidad
			where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
			and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.NMes#">
			and Orden_Comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Orden_Comercial#">
			and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clas_Venta#">
			and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Moneda#">
			group by Periodo, Mes, Orden_Comercial, Clas_Venta
		</cfquery>
			
		<cfquery name = "RsRegDet" datasource="#Session.DSN#">
			select ID_Saldo as Registro, convert(varchar, convert(money,Imp_Ingreso_Nuevo),1) as Ingreso_Movimiento, 		            convert(varchar, convert(money,Imp_Costo_Nuevo),1) as Costo_Movimiento, Poliza_Ref as Poliza_Origen, 		            Observaciones, Usulogin as Usuario, convert(varchar(15), 
			Fecha_Actualizacion, 103) as Fecha	
			from SaldosUtilidadMov S
			inner join Usuario U on S.Usuario = U.Usucodigo
			where ID_Saldo in (#ID#)
		</cfquery>

    
    <cfif  RsRegDet.recordcount EQ 0>
		<cfquery name = "RsRegDet" datasource="#Session.DSN#">
			SELECT 'NO EXISTEN MOVIMIENTOS ADICIONALES PARA EL REGISTRO' AS Resultado
		</cfquery>
	</cfif>
    
  	<form method="post" name="frmDetalle" style="margin:0 0 0 0">
		
		<hr>
			<table width=300 align=center><tr><td>
			<cf_web_portlet_start titulo="Informacion de Utilidad Bruta por Orden Comercial">
				<cfif isdefined("RsRegCab") and RsRegCab.recordCount EQ 1>
					<cfset LvarCampos = RsRegCab.getColumnnames()>
					<table width="500" >
						<cfloop query="RsRegCab">
							<cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
								<tr>
									<td width="250" align="right">
										<strong><cfoutput>#LvarCampos[i]#:</cfoutput></strong>
									</td>
									<td>
										<cfoutput>#evaluate("RsRegCab.#LvarCampos[i]#")#</cfoutput>
									</td>
								</tr>
							</cfloop>
						</cfloop>
					</table>
				</cfif> 
			<cf_web_portlet_end>
		 	</td></tr></table>
		<hr>
			<cfif  isdefined("RsRegDet")>
                <cf_web_portlet_start titulo="Información de Movimientos adicionales de Utilidad Bruta por Orden Comercial">
                    <cfset LvarCampos = RsRegDet.getColumnNames()>
                    <div style="width:900px;overflow:scroll">
                        <TABLE border="1" >
                            <TR>
                                <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                    <td style="font-size:8;font-weight:bold">
                                        <cfoutput>#lcase(LvarCampos[i])#</cfoutput>
                                    </td>
                                </cfloop>
                            </TR>
                            <cfloop query="RsRegDet">   
                                <TR>
                                    <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                        <td style="font-size:10">
                                        <cfoutput>#evaluate("RsRegDet.#LvarCampos[i]#")#&nbsp;</cfoutput>
                                        </td>
                                    </cfloop>
                                </TR>
                            </cfloop> 
                        </TABLE>
                    </div>
                <cf_web_portlet_end>
            </cfif>
	</form>
   	<!----------------------------------------------------  --->
	<table align="center">
		<tr>
			<td>
				<form action="../VtasOrdenComercial/ConsultaVtas-Costo-form.cfm" method="post" style="margin:0 0 0 0" name="sql">
					<input type="submit" name="btnRegresar" value="Regresar">
				</form>
			</td>			
		</tr>
	</table>
   <!----------------------------------------------------  --->

	<cfset LvarFiltro = ""> 
	<cfset LvarNavegacion = "">

 <cf_templatefooter>