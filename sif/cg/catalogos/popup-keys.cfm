<cfquery name="rsInformacion" datasource="#session.dsn#">
	SELECT 
    		 hpcr.Cmayor 
    		,hpcr.OficodigoM
            ,hpcr.PCRdescripcion
            ,hpcr.Ulocalizacion
            ,hpcr.PCRdesde
            ,hpcr.PCRhasta
            ,hpcr.PCRregla
            ,(SELECT Usulogin FROM Usuario WHERE Usucodigo = u.Usucodigo) as UsuarioAdd
            ,(SELECT Usulogin FROM Usuario WHERE Usucodigo = hpcr.HUsucodigo) as UsuarioDel
            ,hpcr.HBMfechaalta
            ,(SELECT PCRregla FROM HPCReglas WHERE PCRid = hpcr.PCRref) as ref
            
    FROM HPCReglas hpcr
    	INNER JOIN Usuario u
        	ON u.Usucodigo = hpcr.Usucodigo
    WHERE hpcr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    	AND hpcr.PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.PCRid#">
</cfquery>
<cfquery datasource="#session.dsn#" name="rsMascara">
	Select a.PCRGDescripcion
	from PCReglaGrupo a
			inner join CtasMayor b
				 on a.Cmayor = b.Cmayor
				and a.Ecodigo = b.Ecodigo
			inner join PCEMascaras c
				on c.PCEMid = b.PCEMid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	  and a.PCRGid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.LvarGrp#">
</cfquery>
<style type="text/css">
table
{
	font-family:Verdana, Geneva, sans-serif;
	font-size:12;
}
.TituloTB
{
	-moz-border-radius: 5px;
	border : 1px solid #003366;
	background-color:#003366;
	text-align:center;
	font-variant:normal;
	font-size:12px;
	color:#FFF;
}
.tabla2
{
	-moz-border-radius: 5px;
	border : 1px solid #003366;	
}
.boton
{
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #003366;
	background-color: #FFF;	
}
</style>
<table width="100%" border="0">
  <tr>
		<td class="TituloTB" height="25">
				Informaci&oacute;n de la Regla
				<b><br>GRUPO - <cfoutput>#trim(rsMascara.PCRGDescripcion)#</cfoutput></b>
        </td>
  </tr>
  <tr>
    <td>
      <table width="100%" class="tabla2">
        <tr>
            <td width="40%"><b>Cuenta de Mayor:</b></td>
            <td><cfoutput>#rsInformacion.Cmayor#</cfoutput>
        </tr>
        <tr>
            <td width="40%"><b>Oficina:</b></td>
            <td><cfoutput>#rsInformacion.OficodigoM#</cfoutput>
        </tr>
        <tr>
            <td width="40%"><b>Regla de validaci&oacute;n:</b></td>
            <td><cfoutput>#rsInformacion.PCRregla#</cfoutput>
        </tr>
        <cfif #rsInformacion.ref# neq "">
        <tr>
            <td width="40%"><b>Regla de referencia:</b></td>
            <td><cfoutput>#rsInformacion.ref#</cfoutput>
        </tr>
        </cfif>
        <tr>
            <td width="40%"><b>Observaciones:</b></td>
            <td><cfoutput>#rsInformacion.PCRdescripcion#</cfoutput>
        </tr>
        <tr>
            <td width="40%"><b>Fecha desde:</b></td>
            <cfset fechaDesde = LSDateFormat(rsInformacion.PCRdesde,'dd/mm/yyyy')>
            <td><cfoutput>#fechaDesde#</cfoutput>
        </tr>
        <tr>
            <td width="40%"><b>Fecha hasta:</b></td>
             <cfset fechaHasta = LSDateFormat(rsInformacion.PCRhasta,'dd/mm/yyyy')>
            <td><cfoutput>#fechaHasta#</cfoutput>
        </tr>
        <tr>
            <td width="40%"><b>Usuario que agreg&oacute; la regla:</b></td>
            <td><cfoutput>#rsInformacion.UsuarioAdd#</cfoutput>
        </tr>
        <tr>
            <td width="40%"><b>Usuario que elimin&oacute; la regla:</b></td>
            <td><cfoutput>#rsInformacion.UsuarioDel#</cfoutput>
        </tr>
        <tr>
            <td width="43%"><b>Fecha en que se elimin&oacute; la regla:</b></td>
             <cfset fechaAlta = LSDateFormat(rsInformacion.HBMfechaalta,'dd/mm/yyyy')>
            <td><cfoutput>#fechaAlta#</cfoutput>
        </tr>
        <tr>
       		 <td width="40%" height="40" valign="middle" colspan="2">
                 <center>
                    <input type="button" class="boton" name="btCerrar" id="btCerrar" value="Cerrar" onclick="javascript: window.close();" />
                 </center>
             </td>
        </tr>
    	</table>
		<td>
   </tr> 
</table>
