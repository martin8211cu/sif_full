
<!--- <cf_dump var="Form"> --->

<cfquery name="rsBuscaInsumos" datasource="#Session.DSN#">
        select distinct pin.ecodigo, pin.Otcodigo, pin.OTseq, pin.MPcantidad, pin.MPseguimiento,
                a.Aid, a.Adescripcion, a.Ccodigo,
                pc.almid,
                e.Eexistencia,
                isnull((select sum(i.Pexistencia) from Prod_Inventario i
                        where pin.ecodigo = i.ecodigo
                            and pin.OTcodigo = i.OTcodigo
                            and	pin.artid = i.artid),0) as Pexistencia,
                u.Udescripcion
        from Prod_Insumo pin
            inner join Articulos a on
                    pin.ecodigo = a.ecodigo
                and	pin.artid = a.aid	
            inner join Prod_ClasificacionAlmacen pc on
                    a.ecodigo = pc.ecodigo
                and a.Ccodigo = pc.Ccodigo
            inner join Unidades u on
                    a.ecodigo = u.ecodigo
                and	a.Ucodigo = u.Ucodigo
            left join Existencias e on	
                    pin.ecodigo = e.ecodigo
                and a.aid = e.aid
                and pc.almid = e.alm_aid
            left join Prod_Inventario piv on
                    pin.ecodigo = piv.ecodigo
                and pin.OTcodigo = piv.OTcodigo
                and pin.artid = piv.artid
        where pin.ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                and pin.OTcodigo = <cfqueryparam value="#OT#" cfsqltype="cf_sql_varchar">
        order by pin.OTseq
</cfquery>

<cfset NumRegsInsumos = #rsBuscaInsumos.recordcount#>

 <table width="100%" border="0">
 	
  	<tr>
      <td>&nbsp; &nbsp; &nbsp; &nbsp;</td> 
      <td align="center" width="25%"><b>Articulo</b></td>
      <td>&nbsp; &nbsp; &nbsp; &nbsp;</td>
      <td align="center"><b>Cantidad <br /> en Inventario</b></td>
      <td>&nbsp; &nbsp; &nbsp; &nbsp;</td>
      <td align="center"><b>Cantidad <br /> en Produccion</b></td>
      <td>&nbsp; &nbsp; &nbsp; &nbsp;</td>
      <td align="center"><b>Cantidad <br /> Planeada(OT)</b></td>
      <td>&nbsp; &nbsp; &nbsp; &nbsp;</td>
      <td align="center"><b>Cantidad <br /> Requerida</b></td>
      <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</td>
      <td align="center"><b>Unidad/Medida</b></td>
    </tr>
       <tr></tr>
       <tr></tr>
</table>
<HR SIZE=4 WIDTH="100%" COLOR="#0066CC" ALIGN = CENTER>
<table width="100%" border="0">
	<tr><td>&nbsp; &nbsp;</td> </tr>
   	<cfloop query="rsBuscaInsumos">  
        <tr>
          <td></td> 
          <td align="left"><cfoutput>#rsBuscaInsumos.Adescripcion#</cfoutput></td>
          <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</td> 
          <td align="right"><cfoutput>#rsBuscaInsumos.Eexistencia#</cfoutput></td>
          <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</td>
          <td align="right"><cfoutput>#rsBuscaInsumos.Pexistencia#</cfoutput></td>
          <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</td>
          <td align="right"><cfoutput>#rsBuscaInsumos.MPcantidad#</cfoutput></td>
          <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</td>

			   <td><input name="CantPI" tabindex="1" type="text"  align="right" value="0" size="10" maxlength="10" onblur="<cfoutput>javascript: return validaEIP(this,#rsBuscaInsumos.Pexistencia#,#rsBuscaInsumos.MPcantidad#)</cfoutput>"></td> 
          	  <input type="hidden" name="Artid" value="<cfoutput>#rsBuscaInsumos.Aid#</cfoutput>" default="0"/>
              <input type="hidden" name="OTsec" value="<cfoutput>#rsBuscaInsumos.OTseq#</cfoutput>" default="0"/>
          <td>&nbsp; &nbsp;</td>
          <td align="center"><cfoutput>#rsBuscaInsumos.Udescripcion#</cfoutput></td>
        </tr>
	</cfloop>
    <tr> <td>&nbsp;</td></tr>
    <tr> <td>&nbsp;</td></tr>
    <tr> <td>&nbsp;</td></tr>
    <tr> <td>&nbsp;</td></tr>
 </table>
 
<input name="Registro" type="hidden" value="INICIAL"/>

<!--- ************************************************************* --->

<script language="JavaScript1.2" type="text/javascript">
	function validaEIP(CantPI,ExistP,CSolict){
		var error = false;
		var Cant = 0;
		var Suma = 0;
		var Cant = parseInt(CantPI.value)
		var Suma = ExistP + Cant
		var mensaje = "Se presentaron los siguientes errores:\n";

		if (CantPI.value == "" ){
			error = true;
			mensaje += "El campo Cantidad es requerido.\n";
		}
		
		if (Suma > CSolict){
			error = true;
			mensaje += "La Cantidad Solicitada es mayor";
		} 

		if ( error ){
			alert(mensaje);
			return false;
		}else{
			return true;
		}
	  }

</script>

