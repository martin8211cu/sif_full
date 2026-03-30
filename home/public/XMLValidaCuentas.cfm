<cfinvoke component="SOIN_HSBC_XML" method="fnGeneraCuentas" returnvariable="LvarXML">
	<cfinvokeargument name="Empresa"  value="#session.Ecodigo#">
	<cfinvokeargument name="Conexion" value="#session.DSN#">
</cfinvoke>
<cfset selectedElements = XmlSearch(LVarXML, "/rs/rows/row/id")>
<table>
	<tr>
    	<td>Linea</td>
    	<td>Tipo Cliente</td>
    	<td>Cliente</td>
        <td>Cuenta</td>
        <td>Fecha</td>
        <td>Monto</td>
        <td>Movimiento</td>
    </tr>
    <cfloop index="i" from="1" to="#ArrayLen(selectedElements)#">
        <tr>
        <cfoutput>
            <td>#LvarXML.rs.rows.row[i].Id.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].CustType.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Customer.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Account.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Date.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Amount.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Descr.XMLtext#</td>
        </cfoutput>
        </tr>
        <cfset i = i + 1>
    </cfloop>
</table>

