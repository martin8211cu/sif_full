<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Detalle de la Nómina'>
<cf_htmlreportsheaders
	filename="Nomina#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls"
	ira="interfaz925PMI-Consulta.cfm" print="false" back="false">

		<cfquery name = "RsRegDoctoCab" datasource="sifinterfaces">
			select PMI_GL_COD_EJEC as Nomina, PMI_GL_DESCRIPCION Descripción, PMI_GL_FECHA_EMISI Fecha, PMI_GL_COD_EJEC_RE as Nomina_a_Cancelar, case PMI_GL_CANCELACION when 'Y' then 'Si' when 'N' then 'No' end as Cancelación
			from
			PS_PMI_GL_HEADER
			where
			PMI_GL_COD_EJEC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PMI_GL_COD_EJEC#">
		</cfquery>
    
      <!---  <cfquery name = "RsRegDoctoErr" datasource="sifinterfaces">
			select Error
            from Interfaz40
			where Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">
            and Modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Modulo#">
            and NumeroSocio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumeroSocio#">
            and Transaccion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Transaccion#">
            and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">
            and isnull(convert(varchar,Error),'') not like ''
		</cfquery>--->
<cfset minisifdb = Application.dsinfo.minisif.schema>

        <cfquery name = "RsRegDoctoDet" datasource="sifinterfaces">
			SELECT PMI_GL_COD_EJEC AS Nómina,
                   PMI_GL_LINEA No_detalle,
                   PMI_GL_RUBRO AS Rubro,
                   PMI_GL_SUBRUBRO AS SubRubro,
                   PMI_GL_EMPLEADO AS No_empleado,
                   PMI_GL_DESCRIPCION AS Descricpion,
                   PMI_GL_TIPO AS Movimiento,
                   RTrim(PMI_GL_IMPORTE) AS Monto,
                   PMI_GL_CTRO_COSTOS AS Centro_Costo,
                   PMI_GL_CUENTA AS Concepto_Servicio,
                   PMI_MONEDA AS Moneda,
                   PMI_FORMA_PAGO AS Forma_de_Pago,
                   coalesce(MC.Cformato,'Sin Cuenta') as Cuenta,
                   coalesce(PMI_GL_COMPLEMENTO,'Sin Complemento') AS Complemento
            FROM PS_PMI_GL_DET_NOM DM
                left join #minisifdb#.dbo.Conceptos MC 
                  on DM.PMI_GL_CUENTA = MC.Ccodigo
                  and DM.Ecodigo = MC.Ecodigo
				where PMI_GL_COD_EJEC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PMI_GL_COD_EJEC#">
		</cfquery>
    
 	<form method="post" name="frmDetalle" style="margin:0 0 0 0">
		<hr>
            <table width=500 align=center><tr><td>
			<cf_web_portlet_start titulo="DOCUMENTO CANCELACION">
				<cfif isdefined("RsRegDoctoCab") and RsRegDoctoCab.recordCount EQ 1>
					<cfset LvarCampos = RsRegDoctoCab.getColumnnames()>
					<table width="100%" border="1">
						<TR>
                            <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                <td style="font-size:12;font-weight:bold">
                                    <cfoutput>#ucase(LvarCampos[i])#</cfoutput>
                                </td>
                            </cfloop>
                        </TR>
                        <cfloop query="RsRegDoctoCab">
                            <TR>
                                <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                    <td style="font-size:10">
                                    <cfoutput>#evaluate("RsRegDoctoCab.#LvarCampos[i]#")#&nbsp;</cfoutput>
                                    </td>
                                </cfloop>
                            </TR>
                        </cfloop>
					</table>
				</cfif>
			<cf_web_portlet_end>
		 	</td></tr></table>
            <cfif isdefined("RsRegDoctoErr") and RsRegDoctoErr.recordcount GT 0>
                <table>
                    <tr>
                        <td align="left">
                            <strong>ERROR:</strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <cfoutput>#RsRegDoctoErr.Error#</cfoutput>
                        </td>
                    </tr>
                </table>
            </cfif>
        <hr>
			<table width=500 align=center><tr><td>
			<cf_web_portlet_start titulo="DOCUMENTOS A CANCELAR">
				<cfif isdefined("RsRegDoctoDet") and RsRegDoctoDet.recordCount GTE 1>
					<cfset LvarCampos = RsRegDoctoDet.getColumnnames()>
					<table width="100%" border="1">
						<TR>
              <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                  <td style="font-size:12;font-weight:bold">
                      <cfoutput>#ucase(LvarCampos[i])#</cfoutput>
                  </td>
              </cfloop>
            </TR>
            <cfloop query="RsRegDoctoDet">
                <TR>
                    <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                        <td style="font-size:10">
                        <cfoutput>#evaluate("RsRegDoctoDet.#LvarCampos[i]#")#</cfoutput>
                        </td>
                    </cfloop>
                </TR>
            </cfloop>
					</table>
				</cfif>
			<cf_web_portlet_end>
		 	</td></tr></table>
	</form>

   	<!----------------------------------------------------  --->
	<cfoutput>
    <table align="center">
		<tr>
			<td>
				<form action="interfaz925PMI-sql.cfm" method="post" style="margin:0 0 0 0" name="sql">
                	<input type="submit" name="btnRegresar" value="Regresar">
				</form>
			</td>
		</tr>
	</table>
    </cfoutput>
   <!----------------------------------------------------  --->


	<cfset LvarFiltro = "">
	<cfset LvarNavegacion = "">
	<cfset Inicio = True>

 <cf_templatefooter>