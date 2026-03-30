<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  28/03/2014                                              --->
<!--- Última Modificación: 04/05/2014                                 --->
<!--- =============================================================== --->
<!---******************** 	VALIDACIONES	 ******************--->

<!--- 	VERIFICA QUE EL SOCIO NO EXISTA YA EN EL CATALOGO 	--->
<cfquery name="rsExisteSN" datasource="#Session.DSN#">
    SELECT 	COUNT(1) AS valor
      FROM 	CatalogoArrend
     WHERE 	Ecodigo   =  #Session.Ecodigo#
       AND 	SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">             
</cfquery>

<cfquery name="rsCuentaCatalogo" datasource="#session.dsn#">
  SELECT  a.CcuentaIDif AS CcuentaIDif, b.Cformato AS CformatoIDif, b.Cdescripcion AS CdescripcionIDif, 
      a.CcuentaIGan AS CcuentaIGan, c.Cformato AS CformatoIGan, c.Cdescripcion AS CdescripcionIGan
  FROM  CatalogoArrend a 
      INNER JOIN CContables b ON a.CcuentaIDif = b.Ccuenta
      INNER JOIN CContables c ON a.CcuentaIGan = c.Ccuenta
  WHERE a.Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsCatalogo" datasource="#session.dsn#">
  SELECT  a.SNcodigo AS SNcodigo, SNnombre, ArrendNombre, CcuentaIDif, CcuentaIGan, Cid, Observaciones
  FROM  CatalogoArrend a INNER JOIN SNegocios b 
      ON a.SNcodigo = b.SNcodigo AND a.Ecodigo = b.Ecodigo
  WHERE a.Ecodigo = #session.Ecodigo#
</cfquery>

<!--- =============================================================== --->
<!---                   AGREGAR ARRENDAMIENTO NUEVO                   --->
<!--- =============================================================== --->
<cfif IsDefined("Form.Agregar") && (form.modosn NEQ "ALTA" or (form.modosn EQ "ALTA" && rsExisteSN.valor EQ 0))>
  <cfparam name="Observaciones" default="">
  <cftransaction>
    <cfquery name="rsExisteEncab" datasource="#Session.DSN#">
    
        INSERT  INTO  CatalogoArrend (Ecodigo, SNcodigo, ArrendNombre, CcuentaIDif, CcuentaIGan, Cid, Observaciones)
            VALUES  (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Nombre#">,
                <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.CcuentaIDif#">,
                <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.CcuentaIGan#">,
                <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Cid#">,
                <cfqueryparam cfsqltype="cf_sql_char"    value="#Observaciones#">
                )            
    </cfquery>
  </cftransaction>
  <cflocation url="CatalogoArrendamiento-list.cfm">
<cfelseif IsDefined("form.Agregar") && (form.modosn EQ "ALTA" && rsExisteSN.valor GT 0) >
  <script type="text/javascript">alert("Error, El socio ya existe");
    window.history.back();
  </script>
</cfif>
<!--- =============================================================== --->
<!---                    MODIFICAR ARRENDAMIENTO                      --->
<!--- =============================================================== --->
<cfif isDefined("Form.Modificar")>
<cfparam name="Observaciones" default="">
  <cftransaction>
    <cfquery name="rsExisteEncab" datasource="#Session.DSN#">
    
        UPDATE  CatalogoArrend
           SET  CcuentaIDif =   <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.CcuentaIDif#">,
                CcuentaIGan =   <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.CcuentaIGan#">,
                Cid =           <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Cid#">,
                Observaciones = <cfqueryparam cfsqltype="cf_sql_char"    value="#Observaciones#">
         WHERE  Ecodigo =       <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
           AND  SNcodigo =      <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
           AND  ArrendNombre =  <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Nombre#">
    </cfquery>
  </cftransaction>
  <cflocation url="CatalogoArrendamiento-list.cfm">
<cfelseif isDefined("form.Modificar") && (form.modosn EQ "ALTA" && rsExisteSN.valor EQ 0) >
  <script type="text/javascript">alert("El registro no existe");
  window.history.back();</script>
</cfif>
<!--- =============================================================== --->
<!---                    ELIMINAR ARRENDAMIENTO                       --->
<!--- =============================================================== --->
<cfif isDefined("Form.Eliminar")>
<cfparam name="Observaciones" default="">
  <cftransaction>
    <cfquery name="rsExisteEncab" datasource="#Session.DSN#">
    
        DELETE  CatalogoArrend
         WHERE  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
           AND  SNcodigo =      <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
           AND  ArrendNombre =  <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Nombre#">
    </cfquery>
  </cftransaction>
  <cflocation url="CatalogoArrendamiento-list.cfm">
<cfelseif isDefined("form.Eliminar") && rsExisteSN.valor EQ 0 >
  <script type="text/javascript">alert("Error");
  window.history.go(-2);
  </script>
</cfif>