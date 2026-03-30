 <!---
	Catalogo de Status de las tarjetas de credito
	Creado por Hector Garcia Beita
	Fecha: 22/07/2011
--->
<cfif isdefined("url.Descripcion") and not isdefined("form.Descripcion") >
	<cfset form.Descripcion = url.Descripcion >
</cfif>

<cfoutput>
    <form style="margin: 0" action="TCEStatusTarjetas.cfm" name="StatusTarjetaCredito" method="post">
        <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
        <tr>
            <td colspan="2">
                <td width="82" align="right"><strong>Descripci&oacute;n<strong></td>
                                        
                <td width="247" align="left"><input type="text" name="Descripcion_U" size="30" maxlength="30" value="<cfif isdefined('form.Descripcion_U')>#form.Descripcion_U#</cfif>"></td>
                    
                <td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
            </td>	
        </tr>
        </table>
    </form>
</cfoutput>
