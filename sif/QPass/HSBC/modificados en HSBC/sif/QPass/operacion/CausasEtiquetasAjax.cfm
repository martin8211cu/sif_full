<cfquery name="rsCausas" datasource="#session.dsn#">
    select 
    	b.QPvtaConvid, 
        a.QPCid, 
        a.QPCcodigo, 
        a.QPCdescripcion, 
        c.Miso4217 as Moneda, 
        a.QPCmonto as Monto
    from QPCausa a
        inner join QPCausaxConvenio b
            on b.QPCid = a.QPCid
            and b.QPvtaConvid = #url.QPvtaConvid#
        inner join Monedas c
            on c.Mcodigo = a.Mcodigo
    where a.Ecodigo = #session.Ecodigo#
    order by a.QPCcodigo
</cfquery>
<cfoutput>
    <span id="contenedor_Causas">
        <table>
			<cfset LvarCausa = "">
            <cfloop query="rsCausas">
               <tr>
                   <td>#rsCausas.QPCcodigo#&nbsp;&nbsp;&nbsp;</td>
                   <td>#rsCausas.QPCdescripcion#&nbsp;&nbsp;&nbsp;</td>
                   <td align="right">#numberformat(Monto, "999,999,999.00")#</td>
                   <td align="right">#Moneda#</td>
               </tr>
            </cfloop>
        </table>
    </span>
</cfoutput>