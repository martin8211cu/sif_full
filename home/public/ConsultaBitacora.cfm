
<cfdump var="#form#">

    <cfif not isDefined('form.fltStatus')>
      <cfset form.fltStatus = ''>
    </cfif>
    <cfif not isDefined('form.NumeroInterfaz')>
      <cfset form.NumeroInterfaz = '-11'>
    </cfif>


    <form name="form1" action="ConsultaBitacora.cfm" method="post">
      <h2>Ingrese los datos a consultar - Consulta de Bitacora</h2>
      <label>Numero Interfaz:</label>
      <select name="NumeroInterfaz">
        <option value="747" <cfif form.NumeroInterfaz EQ '747'>selected</cfif>>747 - Liquidacion de Ruteros y Cajeros</option>
        <option value="748" <cfif form.NumeroInterfaz EQ '748'>selected</cfif>>748 - Recuperacion de Transacciones Facturacion </option>
      </select>

      <label>Estado:</label>

      <select name="fltStatus">
        <option value="100"  <cfif Form.fltStatus EQ "100">selected</cfif>>(Cola de procesos pendientes de finalizar...)</option>
        <option value="1"    <cfif Form.fltStatus EQ "1">selected</cfif>>Procesos Inactivos</option>
        <option value="2"    <cfif Form.fltStatus EQ "2">selected</cfif>>Procesos en Ejecucion</option>
        <option value="3"    <cfif Form.fltStatus EQ "3">selected</cfif>>Procesos Pendientes con Error</option>
        <option value="5"    <cfif Form.fltStatus EQ "5">selected</cfif>>Procesos con Error en el spFinal</option>
        <option value="100" <cfif Form.fltStatus EQ "-100">selected</cfif>>(Bitacora de procesos finalizados...)</option>
        <option value="10"  <cfif Form.fltStatus EQ "-10">selected</cfif>>Procesos Finalizados con Exito</option>
        <option value="11"  <cfif Form.fltStatus EQ "-11">selected</cfif>>Procesos Finalizados con Error</option>
        <option value="101" <cfif Form.fltStatus EQ "-101">selected</cfif>>Procesos Cancelados</option>
        <option value="1"   <cfif Form.fltStatus EQ "-1">selected</cfif>>Procesos Inactivos Cancelados</option>
        <option value="2"   <cfif Form.fltStatus EQ "-2">selected</cfif>>Procesos Activos Cancelados</option>
        <option value="3"   <cfif Form.fltStatus EQ "-3">selected</cfif>>Procesos Pendientes con Error Cancelados</option>
        <option value="12"  <cfif Form.fltStatus EQ "-12">selected</cfif>>Procesos con Error antes de la Ejecucion</option>
      </select>


      <input type="submit" name="btnBuscar" value="Buscar">
    </form>


<cfif isDefined('form.btnBuscar')>
  <cfoutput>
    <cfquery name="rsSQL" datasource="sifinterfaces" maxrows="200">
          select i.IdProceso,i.XML_E
            from InterfazDatosXML i
            inner join InterfazBitacoraProcesos b
            on i.IdProceso = b.IdProceso
           where i.NumeroInterfaz = #form.NumeroInterfaz#
           and i.TipoIO = 'I'
           and b.StatusProceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fltStatus#">
           order by FechaInclusion desc
     </cfquery>

     <cf_dump var="#rsSQL#">
       
     </cf_dump>

    <table border="1" bgcolor="gray">
      <tr>
        <td>ID</td>
        <td>NumDocumento</td>
        <td>Fecha</td>
      </tr>
      <cfloop query="rsSQL">
          <cfset myXML = xmlParse(CharsetEncode(rsSQL.XML_E, "utf-8"))>
          <cf_dump var="#myXML#">
            
          </cf_dump>
          <tr>
            <td>#IdProceso#</td>
          </tr>
      </cfloop>

  </cfoutput>
  </table>

</cfif>
