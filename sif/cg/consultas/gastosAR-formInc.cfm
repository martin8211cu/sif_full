<cfoutput>
<table width="99%" align="center" cellpadding="0" cellspacing="0">
	<tr align="center"><td colspan="7" align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>#session.Enombre#</strong></font></td></tr>
	<tr align="center"><td colspan="7" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>Detalle de Gastos por Area de Responsabilidad</strong></font></td></tr>
	<cfif isdefined("area")>
		<tr align="center"><td colspan="7" align="center"><font size="2" face="Times New Roman, Times, serif"><strong>Area de Responsabilidad: #area.descripcion#</strong></font></td></tr>	
	</cfif>
	<tr align="center"><td colspan="7" align="center"><font size="2" face="Times New Roman, Times, serif"><strong>Periodo: #form.mes#/#form.Periodo#</strong></font></td></tr>
</table>
</cfoutput>


<style type="text/css" >
	.linea{ border-right:1px solid black; }
	.cuadro{ border-right:1px solid black;
			 border-top:1px solid black;
			 border-bottom:1px solid black; }
	.cuadro2{  border-top:1px solid black;
			 border-bottom:1px solid black; }
	.lineaArriba{  border-top:1px solid black; }
	.cuadro3{ border-right:1px solid black;
			 border-top:1px solid black; }
	
</style>

<table width="99%" align="center" border="0" cellpadding="2" cellspacing="0"  style="border:1px solid black;">
	<tr>
        <td colspan="2" rowspan="2" style="padding-left:20px; border-bottom:1px solid black; border-right:1px solid black; padding-left:50px;"  class="tituloListas" bgcolor="##f5f5f5"><strong>Descripci&oacute;n</strong></td>
		<td colspan="5" align="center" class="tituloListas" bgcolor="##f5f5f5"><strong>Saldos Contables</strong></td>
	</tr>
	<tr>
		<!---<td rowspan="2" style="border-bottom:1px solid black; border-right:1px solid black;" colspan="2" style="padding-left:20px;" class="tituloListas">Descripci&oacute;n</td>--->
		<td style="border-bottom:1px solid black;" class="tituloListas"  align="right" bgcolor="##f5f5f5"><strong>Saldo Inicial</strong></td>

		<td style="border-bottom:1px solid black;" bgcolor="#FFFFFF"  align="right">D&eacute;bitos</td>
		<td style="border-bottom:1px solid black;" bgcolor="#FFFFFF"  align="right">Cr&eacute;ditos</td>
		<td style="border-bottom:1px solid black;" class="tituloListas"  align="right" bgcolor="##f5f5f5"><strong>Movimientos</strong></td>

		<td style="border-bottom:1px solid black;" class="tituloListas" align="right" bgcolor="##f5f5f5"><strong>Saldo Final</strong></td>
	</tr>

	<cfset tot_monto_mes = 0 >
	<cfset tot_monto_actual = 0 >

	<cfset ptot_monto_mes = 0 >
	<cfset ptot_monto_actual = 0 >

	<cfset dtot_monto_mes = 0 >
	<cfset dtot_monto_actual = 0 >
	
    <cfif form.Resumido>
    	<cfset varAgrupa = "PCDcatid">
    <cfelse>
    	<cfset varAgrupa = "mayor">
    </cfif>
	<cfif form.CorteMayor>
    	<cfset varAgrupa = "mayor">
    </cfif>
<cfoutput query="datos" group="CGARid">	
	<tr>
    	<td colspan="7" style="padding-left:5px;"  class="tituloListas" bgcolor="##f5f5f5">
	        <cfquery name="rsArea" datasource="#session.dsn#">
            	select CGARdescripcion
                from CGAreaResponsabilidad
               	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos.CGARid#">
            </cfquery>
        <strong>Area de Responsabilidad:</strong>&nbsp;&nbsp;&nbsp;&nbsp;#rsArea.CGARdescripcion#
        </td>
    </tr>
	<cfoutput group="#varAgrupa#">
    	<cfif isdefined("datos.mayor") and form.CorteMayor>
			<tr  ><td colspan="7" style="padding-left:15px; "  class="tituloListas" bgcolor="##f5f5f5">
				<strong>Cuenta de Mayor:</strong>&nbsp;&nbsp;&nbsp;&nbsp;#datos.mayor#
			</td>
        </cfif>
			<cfset monto_mes = 0 >
			<cfset monto_actual = 0 >
	
			<cfset pmonto_mes = 0 >
			<cfset pmonto_actual = 0 >

			<cfset dmonto_mes = 0 >
			<cfset dmonto_actual = 0 >

			<cfset padding = 40 >
			<cfoutput>
				<tr>
					<td colspan="2" style="border-right:1px solid black; padding-left: #(datos.nivel*20)+10#" height="40%" nowrap="nowrap">
                    <cfif isdefined("form.CodigoPlan")>
                    	<strong>#datos.PCDvalor# &nbsp;&nbsp;&nbsp;&nbsp;</strong>
					</cfif>                    
                    #datos.descrip#
                    </td>
					<td align="right" style="padding-right: #(datos.nivel - form.nivel)*-padding#; " class="linea" height="10%" nowrap="nowrap">#LSNumberFormat(datos.saldoini,',9.00')#</td>

					<td align="right" bgcolor="##f5f5f5" style="padding-right: #(datos.nivel - form.nivel)*-padding#; " class="linea" height="10%" nowrap="nowrap">#LSNumberFormat(datos.debito,',9.00')#</td>
					<td align="right" bgcolor="##f5f5f5" style="padding-right: #(datos.nivel - form.nivel)*-padding#; " class="linea" height="10%" nowrap="nowrap">#LSNumberFormat(datos.credito,',9.00')#</td>
					<td align="right" style="padding-right: #(datos.nivel - form.nivel)*-padding#; " class="linea" height="10%" nowrap="nowrap">#LSNumberFormat(datos.movmes,',9.00')#</td>

					<td align="right" style="padding-right: #(datos.nivel - form.nivel)*-padding#; " class="linea" height="10%" nowrap="nowrap">#LSNumberFormat(datos.saldofin,',9.00')#</td>
				</tr>

			</cfoutput>

		<!---</cfoutput>--->
        <cfif isdefined("datos.mayor") and form.CorteMayor>
        	<cfquery name="totales" dbtype="query">
            	select mayor, nivel, 
                    sum(saldoini) as saldoini,
                    sum(debito) as debito,
                    sum(credito) as credito,
                    sum(movmes) as movmes,
                    sum(saldofin) as saldofin
                from datos
                where mayor like <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.mayor#">
                and nivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivel#">
                group by mayor,nivel
            </cfquery>
            <tr>
                <td colspan="2" align="center"  class="linea"><strong>SUB-TOTAL</strong></td>
                <td align="right" class="cuadro"><strong>#LSNumberFormat(totales.saldoini,',9.00')#</strong></td>

                <td align="right" class="cuadro" bgcolor="##f5f5f5"><strong>#LSNumberFormat(totales.debito,',9.00')#</strong></td>
                <td align="right" class="cuadro" bgcolor="##f5f5f5"><strong>#LSNumberFormat(totales.credito,',9.00')#</strong></td>

                <td align="right" class="cuadro" ><strong>#LSNumberFormat(totales.movmes,',9.00')#</strong></td>
    
                <td align="right" class="cuadro"><strong>#LSNumberFormat(totales.saldofin,',9.00')#</strong></td>
            </tr>
        </cfif>
	</cfoutput>
	<cfif isdefined("datos.mayor") and form.CorteMayor>
        <tr>
            <td colspan="2">&nbsp;</td>
            <td  >&nbsp;</td>
            <td  >&nbsp;</td>
            <td  >&nbsp;</td>
            <td  >&nbsp;</td>
            <td  >&nbsp;</td>
        </tr>	
    </cfif>
    <cfquery name="totales" dbtype="query">
        select CGARid, nivel, 
            sum(saldoini) as saldoini,
            sum(debito) as debito,
            sum(credito) as credito,
            sum(movmes) as movmes,
            sum(saldofin) as saldofin
        from datos
        where CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos.CGARid#">
        and nivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivel#">
        group by CGARid,nivel
    </cfquery>
    <tr>
        <td colspan="2" align="center"  class="linea"><strong>TOTAL POR AREA</strong></td>
        <td align="right" class="cuadro"><strong>#LSNumberFormat(totales.saldoini,',9.00')#</strong></td>

        <td align="right" class="cuadro" bgcolor="##f5f5f5"><strong>#LSNumberFormat(totales.debito,',9.00')#</strong></td>
        <td align="right" class="cuadro" bgcolor="##f5f5f5"><strong>#LSNumberFormat(totales.credito,',9.00')#</strong></td>

        <td align="right" class="cuadro" ><strong>#LSNumberFormat(totales.movmes,',9.00')#</strong></td>

        <td align="right" class="cuadro"><strong>#LSNumberFormat(totales.saldofin,',9.00')#</strong></td>
    </tr>
    <tr>
		<td colspan="2">&nbsp;</td>
		<td  >&nbsp;</td>
		<td  >&nbsp;</td>
		<td  >&nbsp;</td>
		<td  >&nbsp;</td>
		<td  >&nbsp;</td>
	</tr>	
</cfoutput>

    <cfquery name="totales" dbtype="query">
        select 
            sum(saldoini) as saldoini,
            sum(debito) as debito,
            sum(credito) as credito,
            sum(movmes) as movmes,
            sum(saldofin) as saldofin
        from datos
        where nivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivel#">
    </cfquery>
	<cfoutput>
	<tr>
		<td colspan="2" align="center"  class="linea"><strong>GRAN TOTAL</strong></td>
        <td align="right" class="cuadro"><strong>#LSNumberFormat(totales.saldoini,',9.00')#</strong></td>

        <td align="right" class="cuadro" bgcolor="##f5f5f5"><strong>#LSNumberFormat(totales.debito,',9.00')#</strong></td>
        <td align="right" class="cuadro" bgcolor="##f5f5f5"><strong>#LSNumberFormat(totales.credito,',9.00')#</strong></td>

        <td align="right" class="cuadro" ><strong>#LSNumberFormat(totales.movmes,',9.00')#</strong></td>

        <td align="right" class="cuadro"><strong>#LSNumberFormat(totales.saldofin,',9.00')#</strong></td>
	</tr>
	</cfoutput>
</table>

<table width="99%">
	<tr><td colspan="7" align="center">--- Fin del reporte ---</td></tr>
</table>