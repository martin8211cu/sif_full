<form action="ReorderPoint.cfm" name="fmROP" method="post">
<table border="0" align="center">
	<tr>
    	<td>Almacén Inicial</td>
        <td><cf_sifalmacen form="fmROP" Aid="AidIni" Almcodigo="AlmcodigoIni" Bdescripcion="BdescripcionIni" frame = "fralmacenIni" FilUsucodigo="yes"></td>
        <td width="50px">&nbsp;</td>
        <td>Almacén Final</td>
        <td><cf_sifalmacen form="fmROP" Aid="AidFin" Almcodigo="AlmcodigoFin" Bdescripcion="BdescripcionFin" frame = "fralmacenFin" FilUsucodigo="yes"></td>
    </tr>
    <tr>
    	<td>Clasificación Inicial</td>
        <td> <cf_sifclasificacion form="fmROP" frame="cli" id="Ccodigo" name="CcodigoclasIni" desc="CdescripcionIni"></td>
        <td width="50px">&nbsp;</td>
        <td>Clasificación Final</td>
        <td><cf_sifclasificacion form="fmROP" frame="cli" id="Ccodigo" name="CcodigoclasFin" desc="CdescripcionFin"></td>
    </tr>
    <tr>
    	<td>Nivel de Urgencia:</td>
        <td>
        	<select name="NivelU">
            	<option value="T">(Todos)</option>
                <option value="B">Bajo el Minimo</option>
                <option value="S">Sobre el Minimo</option>
            </select>
        </td>
    </tr>
    <tr>
    	<td nowrap="nowrap" align="center" colspan="5">
        	 <input type="submit" name="btnGenerar"   id="btnGenerar" class="BtnAplicar"  value="Ver Existencias">
	     	 <input type="reset"  name="Limpiar"  	  id="Limpiar"    class="btnLimpiar"  value="Limpiar" >
             <cfquery name="rsReorden" datasource="#session.dsn#">
                select count(1) cantidad from INVreorden where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
            </cfquery>
            <cfif rsReorden.cantidad>
            	<input type="submit"  name="btnCargar"  id="btnCargar"  class="btnNormal"  value="Calculo Previo" >
            </cfif>
        </td>
    </tr>
</table>
</form>