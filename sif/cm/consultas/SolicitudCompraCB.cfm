<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif isdefined("rsTipoSolicitud")>
	<cfset CMSid=#rsTipoSolicitud.CMSid#>
    <cfset ESnumero=#rsTipoSolicitud.ESnumero#>
</cfif>

<cfquery datasource="#session.DSN#" name="rsCFSol">
	select ltrim(rtrim(substring(CFdescripcion,1,5))) as CFdescripcion, sc.CMTScodigo from ESolicitudCompraCM sc 
	inner join CFuncional cf on sc.CFid = cf.CFid and sc.Ecodigo = cf.Ecodigo                      
    inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = sc.Ecodigo
    where ESnumero = #ESnumero# and sc.Ecodigo = #session.Ecodigo# and ECFencargado = 1 
</cfquery>

<cfquery datasource="#session.dsn#" name="rsBeneficiario">
		select ESOobs
		from ESolicitudCompraCM s
		where ESnumero = #ESnumero# and s.Ecodigo = #session.Ecodigo# 
		and ltrim(rtrim(s.ESOobs)) = (select distinct ltrim(rtrim(de.DEapellido1+
		' '+de.DEapellido2+' '+de.DEnombre)) as Nombre
						    from ESolicitudCompraCM c
							inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
							inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            			    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			                where ESnumero = #ESnumero# and c.Ecodigo = #session.Ecodigo# 
							and ECFencargado = 1)
</cfquery>

<cfquery name="Empresa" datasource="#Session.DSN#">
	select Edescripcion,ETelefono1,EDireccion1,ts_rversion,EIdentificacion   from Empresas where Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsSolCompra" datasource="#session.dsn#">
	select  CFdescripcion, ESfalta, ESlugarentrega, ESobservacion, case CMTScodigo 
    when '001' then 'BIENES DE CONSUMO'
	when '002' then 'ACTIVO FIJO'
	when '003' then 'SERVICIOS'
	end as tipoC,a.ESnumero,
	DSconsecutivo,dsm.Ucodigo, DSfechareq,DScant,DSdescripcion,Usucodigo,
    art.Acodigo,DSdescalterna,DSobservacion,DATEDIFF(dd,ESfalta,DSfechareq) as dias
 	from ESolicitudCompraCM a  
 	inner join CFuncional d on a.CFid = d.CFid 
 	left join DSolicitudCompraCM dsm 
    	left join Articulos art on dsm.Ecodigo=art.Ecodigo and art.Aid=dsm.Aid
    on a.ESidsolicitud=dsm.ESidsolicitud and a.ESnumero=dsm.ESnumero 
	 where a.ESnumero=#ESnumero#
	 AND a.Ecodigo = #session.Ecodigo#
      order by DSconsecutivo
</cfquery>
<cfquery name="rslongcampos" datasource="#session.dsn#">
    SELECT CHARINDEX('2)',DSdescalterna) as fcda1,LEN(DSdescalterna) as fcda2,
    CHARINDEX('2)',DSobservacion )as fco1,CHARINDEX('3)',DSobservacion )as fco2,
    CHARINDEX('4)',DSobservacion )as fco3,CHARINDEX('5)',DSobservacion )as fco4,LEN(DSobservacion) as fco5
    from DSolicitudCompraCM
    where ESnumero=#ESnumero#
     AND Ecodigo=#session.Ecodigo#
</cfquery>
<cfset campo1="Normas/Niveles de Inspección: ">
    <cfset campo2="Tipo de Garantia: ">
    <cfset campo3="Plurianualidad">
    <cfset campo4="Registros Sanitarios">
    <cfset campo5="% De Garantia:">
    <cfset campo6="Capacitación">
    <cfset campo7="Importe Poliza de Responsabilidad Civil:">
<cfif isdefined ("rslongcampos") and  len(rsSolCompra.DSdescalterna) and len(rsSolCompra.DSobservacion)>
    <cfset c1=#rslongcampos.fcda1#-1>
    <cfset c2=rslongcampos.fcda2-rslongcampos.fcda1>
    <cfset c3=#rslongcampos.fco1#-1>
    <cfset c4=rslongcampos.fco2-rslongcampos.fco1>
    <cfset c5=rslongcampos.fco3-rslongcampos.fco2>
    <cfset c6=rslongcampos.fco4-rslongcampos.fco3>
    <cfset c7=rslongcampos.fco5-rslongcampos.fco4>
    <!--- El largo no puede ser menor a 0 por que da error el substring --->
	<cfif c1 LT 0> <cfset c1 = 0> </cfif>
    <cfif c2 LT 0> <cfset c2 = 0> </cfif>
    <cfif c3 LT 0> <cfset c3 = 0> </cfif>
    <cfif c4 LT 0> <cfset c4 = 0> </cfif>
    <cfif c5 LT 0> <cfset c5 = 0> </cfif>
    <cfif c6 LT 0> <cfset c6 = 0> </cfif>
    <cfif c7 LT 0> <cfset c7 = 0> </cfif>
    
    <cfquery name="campos" datasource="#session.dsn#">
        select substring(DSdescalterna,1,#c1#) as campo1, 
        substring(DSdescalterna,#rslongcampos.fcda1#,#c2#) as campo2,    
        substring(DSobservacion,1,#c3#) as campo3,
        substring(DSobservacion,#rslongcampos.fco1#,#c4#) as campo4,
        substring(DSobservacion,#rslongcampos.fco2#,#c5#) as campo5,
        substring(DSobservacion,#rslongcampos.fco3#,#c6#) as campo6,
        substring(DSobservacion,#rslongcampos.fco4#,#c7#) as campo7
        from DSolicitudCompraCM
        where ESnumero=#ESnumero#
         AND Ecodigo = #session.Ecodigo# 
    </cfquery>
    <cfset campo1=campos.campo1>
    <cfset campo2=campos.campo2>
    <cfset campo3=campos.campo3>
    <cfset campo4=campos.campo4>
    <cfset campo5=campos.campo5>
    <cfset campo6=campos.campo6>
    <cfset campo7=campos.campo7>
</cfif>    
<style type="text/css" >
					.Encabezados {
						font-weight:bold; 
					}
					.Datos
					{
						font-size:11px;
						font-family:Arial, Helvetica, sans-serif;
						line-height:8px;
					}
				</style>
<cfoutput>
<table width="100%">
	<strong>
	<tr><td align="center" style="font-size:16px">COLEGIO DE BACHILLERES</td></tr>
    <tr><td align="center" style="font-size:16px">DIRECCION DE SERVICIOS ADMINISTRATIVOS Y BIENES</td></tr>
    <tr><td align="center" style="font-size:16px">SUBDIRECCION DE BIENES Y SRVICIOS</td></tr>
    <tr><td align="center" style="font-size:16px">DEPARTAMENTO DE COMPRAS</td></tr>
    <tr>
      <td style="font-size:16px">REQUISICION #rsSolCompra.tipoC#</td></tr>
    </strong>
</table>

<table  border="1" width="100%" class="Datos" >
  <tr>
    <td>
        <table width="100%" >
          <tr><td >Area Requiriente: #rsSolcompra.CFdescripcion#</td></tr>
        </table>
    </td>
  </tr>
  <tr>
    <td>
        <table width="100%">
          <tr><td class="Datos">Requisición No #rsSolcompra.ESnumero# - #rsSolcompra.ESobservacion#</td></tr>
        </table>
    </td>
  </tr>
</table>
  <table border="1" width="100%">
  <tr>
  	<td width="22%" class="Datos">
    	<table width="100%" >
        	<tr><td >Fecha de Elaboración: </td></tr>
            <tr><td >#Dateformat(rsSolCompra.ESfalta,'dd/mm/yyyy')#</td></tr><tr><td>&nbsp;</td></tr>
            <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
      </table>
    </td>
    
    <td width="44%" class="Datos">
    	<table width="100%" >
        	<tr><td>Fecha Requerida:</td></tr>
            <tr><td>#Dateformat(rsSolcompra.DSfechareq,'dd/mm/yyyy')#</td></tr><tr><td>&nbsp;</td></tr>
   		  	<tr><td>Plazo (Orden de Surtimiento</td></tr>
        	<tr><td>Dias Naturales): #rsSolCompra.dias#</td></tr>
            <tr><td>&nbsp;</td></tr>
        </table>
    </td>
    <td width="34%" class="Datos">
    	<table width="100%" >
      		<tr>
      		<td> Existencia en almacen</td></tr>   
			<tr><td>&nbsp;</td></tr>
        	<tr><td>Presupuesto</td></tr>
        	<tr><td>&nbsp;</td></tr>
        	<tr><td>#campo3#</td></tr>
        	<tr><td>&nbsp;</td></tr>
        </table>
    </td>
  </tr>
  <tr>
  	<td width="22%" class="Datos">
    	<table width="100%" >
        	<tr>
        	  <td>Tipo de Procedimiento</td></tr>
            <tr><td>&nbsp;</td></tr>
            <tr>
              <td>Anexos: (SI)&nbsp;(NO)</td></tr>
            <tr><td>Muestras: (SI)&nbsp;(NO)</td></tr>
            <tr><td>&nbsp;</td></tr>
            <tr>
              <td>Lugar de Entrega</td></tr>
            <tr>
              <td>#rsSolCompra.ESlugarentrega#</td></tr>
        </table>    
    </td>
    <td width="44%" class="Datos">
    	<table width="100%" >
        	<tr>
        	  <td>#campo1#</td></tr>
            <tr>
        	<tr><td>&nbsp;</td></tr>
            <tr>
              <td>#campo4#</td></tr>
            <tr>
              <td>&nbsp;</td></tr>
            <tr><td>&nbsp;</td></tr>
            <tr>
              <td>#campo6#</td></tr>
            <tr><td>&nbsp;</td></tr>
      </table>
    </td>
	<td width="34%" class="Datos">
    	<table width="100%">
        	<tr>
        	  <td>#campo2#</td></tr>
            <tr><td>&nbsp;</td></tr>
            <tr>
              <td>#campo5#</td></tr>
            <tr><td>&nbsp;</td></tr>
            <tr>
              <td>#campo7#</td></tr>
            <tr><td></td></tr>
            <tr><td>&nbsp;</td></tr>
    	</table>
    </td>
  </tr>
</table>
<table width="100%" border="1" class="Datos">
	<tr><td><table width="100%">
        <tr>
          <td width="100%">Lugar de Adquisicion de los bienes y/o Ejecución del (los) servicio(s) Oficinas Generales</td></tr>
        <tr><td>&nbsp;</td></tr>
    </table></td></tr>    
</table>
<table width="100%" border="1" class="Datos">
	<tr>

                  <td width="15%" align="center">Num. Partida</td>
                  <td width="15%" align="center">Clave Mat. Almacen</td>
                  <td width="15%" align="center">Cantidad</td>
                  <td width="15%" align="center">Unidad de Medida</td>
                  <td width="40%" align="center">Descripcion</td>

    </tr>
</table>
<!--- Aqui  vaciamos cin  el cfloop---->

<table width="100%" border="1" class="Datos"> 
<cfloop query="rsSolCompra">
    <tr>
    	<td width="15%">
            <table width="100%" >
            	<tr><td align="center">#rsSolCompra.DSconsecutivo#</td></tr>
                <!---<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>--->
            </table>
        </td>
        <td width="15%">
            <table width="100%" >
                <tr><td align="center">#rsSolComprA.Acodigo#</td></tr>
                <!---<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>--->
            </table>
        </td>
        <td width="15%">
            <table width="100%" >
                <tr><td align="center">#rsSolcompra.DScant#</td></tr>
                <!---<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>--->
            </table>
        </td>
        <td width="15%">
            <table width="100%" >
            	<tr><td align="center">#rsSolCompra.Ucodigo#</td></tr>
                <!---<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>--->
            </table>
        </td>
        <td width="40%">
            <table width="100%" >
            	<tr><td>#rsSolCompra.DSdescripcion#</td></tr>
                <!---<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>--->
            </table>
        </td>
    </tr>  
</cfloop>            
</table>
<table width="100%" border="1" class="Datos">
	<tr>
    	<td width="30%">
            <table width="100%" >
            	<tr><td align="center">Observaciones</td><tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>                
        	</table>
        </td>
        <td width="35%">
            <table width="100%" >
            	<tr><td align="center">Solicita</td><tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>                
        	</table>
        </td>
        <td width="35%">
            <table width="100%" >
            	<tr><td align="center">Autoriza</td><tr>
                <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>                
        	</table>
        </td>
    </tr>
</table>
</cfoutput>
<table width="100%" ><tr><td class="Datos"> Formato FO-CON-03 	</td></tr></table> 


