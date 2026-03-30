 <cf_templateheader title="Movimientos de Volumenes de Ventas">
	
		<cfquery name = "RsRegErrorCab" datasource="#Session.DSN#">
			select ID_Saldo as Registro, Ecodigo, Periodo, Case Mes when 1 then 'Enero' when 2 then 'Febrero' when 3 then            'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto'            when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end as 																	            Mes, Clas_Venta + Producto as Clave, case Tipo_Documento when 'PRFC' then 'FACT' when 'PRNF' then 'NOFACT' 	            end as Tipo_Documento, Volumen_Documento, Volumen_Actual   
			from SaldosVolumen
			where ID_Saldo = #form.ID_Saldo#
		</cfquery>
		<cfquery name = "RsRegErrorDet" datasource="#Session.DSN#">
			select ID_Saldo as Registro, Volumen_Nuevo as Volumen_Movimiento, Poliza_Ref as Poliza_Origen,            Observaciones, Usulogin as Usuario, convert(varchar(15), Fecha_Actualizacion, 103) as Fecha	
			from SaldosVolumenMov S
			inner join Usuario U on S.Usuario = U.Usucodigo
			where ID_Saldo = #form.ID_Saldo#
		</cfquery>

    
    <cfif  RsRegErrorDet.recordcount EQ 0>
		<cfquery name = "RsRegErrorDet" datasource="#Session.DSN#">
			SELECT 'NO EXISTEN MOVIMIENTOS ADICIONALES PARA EL REGISTRO' AS Resultado
		</cfquery>
	</cfif>
    
  	<form method="post" name="frmDetalle" style="margin:0 0 0 0">
		
		<hr>
			<table width=300 align=center><tr><td>
			<cf_web_portlet_start titulo="Informacion de los Volumenes de Venta">
				<cfif isdefined("RsRegErrorCab") and RsRegErrorCab.recordCount EQ 1>
					<cfset LvarCampos = RsRegErrorCab.getColumnnames()>
					<table width="500" >
						<cfloop query="RsRegErrorCab">
							<cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
								<tr>
									<td width="250" align="right">
										<strong><cfoutput>#LvarCampos[i]#:</cfoutput></strong>
									</td>
									<td>
										<cfoutput>#evaluate("RsRegErrorCab.#LvarCampos[i]#")#</cfoutput>
									</td>
								</tr>
							</cfloop>
						</cfloop>
					</table>
				</cfif> 
			<cf_web_portlet_end>
		 	</td></tr></table>
		<hr>
			<cfif  isdefined("RsRegErrorDet")>
                <cf_web_portlet_start titulo="Información de Movimientos adicionales a los Volumenes de Venta">
                    <cfset LvarCampos = RsRegErrorDet.getColumnNames()>
                    <div style="width:900px;overflow:scroll">
                        <TABLE border="1" >
                            <TR>
                                <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                    <td style="font-size:8;font-weight:bold">
                                        <cfoutput>#lcase(LvarCampos[i])#</cfoutput>
                                    </td>
                                </cfloop>
                            </TR>
                            <cfloop query="RsRegErrorDet">   
                                <TR>
                                    <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                        <td style="font-size:10">
                                        <cfoutput>#evaluate("RsRegErrorDet.#LvarCampos[i]#")#&nbsp;</cfoutput>
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
				<form action="../AnexoVolumenes/ConsultaSaldosVolumen-form.cfm" method="post" style="margin:0 0 0 0" name="sql">
					<input type="submit" name="btnRegresar" value="Regresar">
				</form>
			</td>			
		</tr>
	</table>
   <!----------------------------------------------------  --->

	<cfset LvarFiltro = ""> 
	<cfset LvarNavegacion = "">

 <cf_templatefooter>