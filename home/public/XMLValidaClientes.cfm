<cfinvoke component="SOIN_HSBC_XML" method="fnGeneraClientes" returnvariable="LvarXML">
	<cfinvokeargument name="Empresa"  				value="#session.Ecodigo#">
	<cfinvokeargument name="Conexion" 				value="#session.DSN#">
    <!--- <cfinvokeargument name="TipoCliente" 			value="01"> --->
   <!---  <cfinvokeargument name="IdentificacionCliente" 	value="01-0125-0125"> --->
</cfinvoke>
<cfset selectedElements = XmlSearch(LVarXML, "/rs/rows/row/id")>
<table>
	<tr>
    	<td>Linea </td>
        <td>TipoCliente </td>
    	<td>Identificacion Cliente </td>
        <td>Nombre Cliente </td>
        <td>Direccion </td>
        <td>Telefono1 </td>
        <td>Telefono2 </td>
        <td>TelefonoC </td>
        <td>Correo </td>
        <td>Movimiento</td>
    </tr>
    <cfloop index="i" from="1" to="#ArrayLen(selectedElements)#">
        <tr>
        <cfoutput>
            <td>#LvarXML.rs.rows.row[i].Id.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].TipoCliente.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Identificacion.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Nombre.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Direccion.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Telefono1.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Telefono2.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].TelefonoC.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Correo.XMLtext#</td>
            <td>#LvarXML.rs.rows.row[i].Descr.XMLtext#</td>
        </cfoutput>
        </tr>
        <cfset i = i + 1>
    </cfloop>
</table>

