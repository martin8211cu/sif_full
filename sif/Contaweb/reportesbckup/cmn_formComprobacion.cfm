<cfquery name="rsParametros" datasource="#session.Conta.dsn#">
	select   CGPMES ,CGPANO  from CGX001  
</cfquery>

<cfquery name="rsSucursal" datasource="#session.Conta.dsn#">
	select A.CGE5COD  as CGE5COD, CGE5DES as CGE5DES
	from CGE005 A, CGE000 B
	WHERE A.CGE1COD = B.CGE1COD
	union
	select cod_suc as Codigo, CGE5DES  as Descripcion
	from anex_sucursal
	order by 1 	

</cfquery>

<cfquery name="rsPeriodo" datasource="#session.Conta.dsn#">
	select PERCOD,PERDES   from CGX051
</cfquery>

<cfquery name="rsMeses" datasource="#session.Conta.dsn#">
	select MESCOD,MESNOM   from CGX050
</cfquery>

<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>
<table width="100%" border="0">
  <tr>
    <td>
      <!---********************************************************************************* --->
      <!---** 					INICIA PINTADO DE LA PANTALLA 							  ** --->
      <!---********************************************************************************* --->
      <form action="cmn_RepComprobacion.cfm" method="post" name="form1" onSubmit="">
        <cfoutput>
			  <table width="100%" border="0">
					<td align="left" colspan="4">
						<input type="submit" name="Reporte" value="Consultar" onClick="" tabindex="10">
						<input type="reset" name="Limpiar" value="Limpiar" tabindex="10">
					</td>
					<!---********************************************************************************* --->			
					<tr>
						<td align="center" colspan="4" nowrap bgcolor="##CCCCCC"><strong>Criterios para Filtrar</strong></td>
					</tr>
					<!---********************************************************************************* --->
					<tr>
					  	<td align="left" nowrap><strong>A&ntilde;o:</strong>&nbsp;</td>
					  	<td  colspan="3" nowrap>
							<select name="AnoInicial" tabindex="4">
								<cfloop query="rsPeriodo">
									<option value="#rsPeriodo.PERCOD#" <cfif rsParametros.CGPANO EQ rsPeriodo.PERCOD>selected</cfif>>#rsPeriodo.PERDES#</option>
								</cfloop>
							</select>
					  	</td>
<!--- 						<td align="left" nowrap><strong>A&ntilde;o Final:</strong>&nbsp;</td>
					  	<td nowrap>
							<select name="AnoFinal" tabindex="4">
								<cfloop query="rsPeriodo">
									<option value="#rsPeriodo.PERCOD#" <cfif rsParametros.CGPANO EQ rsPeriodo.PERCOD>selected</cfif>>#rsPeriodo.PERDES#</option>
								</cfloop>
							</select>
					  	</td> 
--->
					</tr>
					<!---********************************************************************************* --->
					<tr>
					  <td align="left" nowrap><strong>Mes Inicial:</strong>&nbsp;</td>
					  <td nowrap >
							<cfoutput>
								<select name="MesInicial" tabindex="4">
								<cfloop query="rsMeses">
								<option value="#rsMeses.MESCOD#" <cfif rsParametros.CGPMES EQ rsMeses.MESCOD>selected</cfif>>#rsMeses.MESNOM#</option>
								</cfloop>
								</select>
							</cfoutput>
					  </td>
					  <td align="left" nowrap><strong>Mes Final:</strong>&nbsp;</td>
					  <td nowrap >
							<cfoutput>
								<select name="MesFinal" tabindex="4">
								<cfloop query="rsMeses">
								<option value="#rsMeses.MESCOD#" <cfif rsParametros.CGPMES EQ rsMeses.MESCOD>selected</cfif>>#rsMeses.MESNOM#</option>
								</cfloop>
								</select>
							</cfoutput>
					  </td>
					</tr>
					<!---********************************************************************************* --->
					<tr>
					  <td align="left" nowrap><strong>Segmento:</strong>&nbsp;</td>
					  <td nowrap>
						<select name="Segmento" tabindex="5">
						  <option value="T">Todas</option>
						  <cfloop query="rsSucursal">
							<option value="#rsSucursal.CGE5COD#" >#rsSucursal.CGE5COD#-#rsSucursal.CGE5DES#</option>
						  </cfloop>
						</select>
					  </td>
					  	<td align="left" nowrap><strong>Incluir Segmento:</strong>&nbsp;</td>
						<td nowrap><input tabindex="7" type="checkbox" checked name="ID_incsucursal"></td>

					</tr>
					<!---********************************************************************************* --->
					<!--- <tr>
					  	<td align="left" nowrap><strong>Incluir Segmento:</strong>&nbsp;</td>
						<td nowrap><input tabindex="6" type="checkbox" name="ID_incsucursal"></td>
					  	<td align="left" nowrap><strong>Saldo Total en Resumen:</strong>&nbsp;</td>
						<td nowrap><input tabindex="6" type="checkbox" name="ID_TotalCtaRes"></td>
					</tr> --->
				<!---********************************************************************************* --->
				</table>
				<input type="hidden" name="ID_REPORTE" id="ID_REPORTE" value="1" tabindex="7">
			    <INPUT type="hidden" style="visibility:hidden" name="ORIGEN" value="R" tabindex="7">
				<INPUT type="hidden" style="visibility:hidden" name="MASCARA" value="" tabindex="7">


        </cfoutput>
		<INPUT type="hidden" style="visibility:hidden" name="CUENTASLIST" value="@">

      </form>
      <!---********************************************************************************* --->
      <!---** 					   FIN PINTADO DE LA PANTALLA 						    ** --->
      <!---********************************************************************************* --->
    </td>
  </tr>
</table>

<!---********************** --->
<!---** AREA DE SCRIPTS  ** --->
<!---********************** --->
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objform1 = new qForm("form1");
</script> 
