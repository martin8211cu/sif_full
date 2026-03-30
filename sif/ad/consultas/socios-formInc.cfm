<style type="text/css" >
	.linea{ border-right:0px solid black; }
	.cuadro{ border-right:0px solid black;
			 border-top:0px solid black;
			 white-space: nowrap;
			 font-size:11px;
			 border-bottom:0px solid black; }
	.cuadro2{  border-top:0px solid black;
			 border-bottom:0px solid black; }
	.lineaArriba{  border-top:0px solid black; }
	.cuadro3{ border-right:0px solid black;
			 border-top:0px solid black; }
	.detalles1{background:#fff;}
	.detalles2{background:#F2F2F2;}
	.clasificacion{background:#A7A7A7;padding:5px;}
	.tituloListas{background:#D3D3D3;}
	
</style>

<cfif snreporte.recordcount NEQ 0>
<cfset maxRows = 70>
<cfset detalle = 0>
<cfset intercalarLineas=0> <!---"detalles1"--->
<cfset snedescripcion = "Sin Clasificaci&oacute;n">
<cfset snedescripcionold = "Sin Clasificaci&oacute;n">

<table width="99%" align="center" cellpadding="0" cellspacing="0" style="margin-bottom:20px;">
	<cfoutput query="snreporte" >
    
    	<cfif (trim(snreporte.SNCEdescripcion) NEQ "") and (trim(snreporte.SNCEdescripcion) NEQ "null")>
			<cfset snedescripcion = snreporte.SNCEdescripcion>
    	</cfif>
    		<cfif #detalle# eq 0 >
                
                <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
                	<tr align="center"><td colspan="8" align="center"><font size="8" face="Verdana, Arial, Helvetica, sans-serif"><strong  style="font-size:18px;"> #session.Enombre# </strong></font></td></tr>
                	<tr align="center"><td colspan="8" align="center"><font size="6" face="Verdana, Arial, Helvetica, sans-serif"><strong style="font-size:16px;"> Detalle de Proveedores </strong></font></td></tr>
               	 <tr align="center"><td colspan="8" align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>Tipo de Proveedor:
                	<cfif #form.snTipo# eq "E" >
                		Internacional
                	<cfelseif #form.snTipo# eq "N">
                		Nacional
               		<cfelse>
                		Todos
                	</cfif></strong></font></td></tr>
                <tr align="center"><td colspan="8" align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>Estado:
                	<cfif #form.snEstado# eq 0 >
                		Activo
                	<cfelseif #form.snEstado# eq 1>
                		Inactivo
                	<cfelse>
                		Todos
               		</cfif>
                </strong></font></td></tr>
                <tr><td colspan="8" align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>Clasificaci&oacute;n: #txtsne# - #txtsnd# </strong></font></td></tr>
                <tr><td align="center" colspan="8">&nbsp; </td></tr>
                <tr><td align="center" colspan="8">&nbsp; </td></tr>
                <tr><td class="clasificacion" colspan="8" align="left">&nbsp;#snedescripcion#</td></tr>
                	<tr>
                		<td colspan="2" class="tituloListas">&nbsp;Proveedor:</td>
                		<td class="tituloListas" class="tituloListas">Tel&eacute;fono:</td>
                		<td class="tituloListas" class="tituloListas">Fax:</td>
                		<td class="tituloListas" class="tituloListas">Email:</td>
                        <td class="tituloListas" class="tituloListas">Contacto:</td>
						<td class="tituloListas" class="tituloListas">Tipo:</td>
                        <td class="tituloListas" class="tituloListas">Clasificaci&oacute;n</td>
                </tr>
			<cfelseif (#detalle# NEQ 0) and ( snedescripcionold NEQ snedescripcion) and (trim(snreporte.SNCEdescripcion) NEQ "") >
                <tr><td colspan="8">&nbsp;  </td></tr>
                <tr><td class="clasificacion"  colspan="8"  align="left">&nbsp;#snedescripcion#</td></tr>
                    <tr>
                        <td colspan="2" class="tituloListas">&nbsp;Proveedor:</td>
                        <td class="tituloListas" class="tituloListas">Tel&eacute;fono:</td>
                        <td class="tituloListas" class="tituloListas">Fax:</td>
                        <td class="tituloListas" class="tituloListas">Email:</td>
                        <td class="tituloListas" class="tituloListas">Contacto:</td>
						<td class="tituloListas" class="tituloListas">Tipo:</td>
                        <td class="tituloListas" class="tituloListas">Clasificaci&oacute;n</td>
                </tr>
                <cfset detalle = detalle+1>
			</cfif> 
            
		
			<cfif snreporte.currentrow gt 0 >
				<tr class="<cfif intercalarLineas EQ 0><cfset intercalarLineas=1>detalles1 <cfelse> <cfset intercalarLineas=0>detalles2</cfif>">
					<td align="left" class="cuadro"> #snreporte.SNidentificacion# </td>
					<td align="left" class="cuadro"> #snreporte.SNnombre# </td>
					<td align="left" class="cuadro"> #snreporte.SNtelefono# </td>
					<td align="left" class="cuadro"> #snreporte.SNFax# </td>
					<td align="left" class="cuadro"> #snreporte.SNemail# </td>
                    <td align="left" class="cuadro"> #snreporte.atencion# </td>
					<td align="left" class="cuadro"> #snreporte.SNtipo# </td>
                    <td align="left" class="cuadro"> <cfif trim(snreporte.SNCDdescripcion) EQ ""> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <cfelse> #snreporte.SNCDdescripcion# </cfif></td>
				</tr>
			</cfif> 
            
            <cfif #detalle# gte maxRows >
            	<cfset detalle = 0>
                <tr><td align="center" colspan="7">&nbsp; </td></tr>
                <tr><td align="center" colspan="7">&nbsp; </td></tr>
                <tr style="page-break-after:always;"></tr>
                
            <cfelseif #detalle# lt maxRows >
            	<cfset detalle = detalle+1>
            </cfif>
            
            
			<cfset snedescripcionold = snreporte.SNCEdescripcion>

 </cfoutput>
<table width="99%">
	<tr><td align="center">--- Fin del reporte ---</td></tr>
</table>

<cfelse>
<table width="99%">
	<tr><td align="center">--- No se encontraron registros ---</td></tr>
</table>

</cfif>
