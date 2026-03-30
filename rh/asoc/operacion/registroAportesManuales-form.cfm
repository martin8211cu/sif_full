<cfset modocambio = isdefined("Form.ACARid") and len(trim(Form.ACARid)) GT 0>
<cfif modocambio>
	<cfquery name="rsForm" datasource="#session.dsn#">
    	SELECT a.ACARid, b.ACAid, a.ACAAid, c.ACATcodigo, c.ACATdescripcion, a.ACARfecha, a.ACARmonto, a.ACARreferencia, a.ts_rversion
        FROM ACAportesRegistro a
        	INNER JOIN ACAportesAsociado aa
            ON aa.ACAAid = a.ACAAid
	        INNER JOIN ACAsociados b
            ON b.ACAid = aa.ACAid
            INNER JOIN ACAportesTipo c
            ON c.ACATid = aa.ACATid
        WHERE a.ACARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACARid#">
    </cfquery>
</cfif>
<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
<cfinvoke component="rh.asoc.Componentes.ACParametros" 	method="init" returnvariable="Parametros">
<cfset Lvar_Periodo 	= Parametros.Get("10",	"Periodo")>
<cfset Lvar_Mes 		= listgetat(lista_meses, Parametros.Get("20",	"Mes"))>

<cfoutput>
<form action="registroAportesManuales-sql.cfm" method="post" name="form1">
	<cfif modocambio>
	    <input type="hidden" name="ACARid" value="#rsForm.ACARid#" />
        <cfset ts = "">	
        <cfinvoke 
            component="sif.Componentes.DButils"
            method="toTimeStamp"
            returnvariable="ts">
                <cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
        </cfinvoke>
        <input type="hidden" name="ts_rversion" value="#ts#">
    </cfif>
    <table align="center" width="90%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="right" width="30%"><strong>#LB_Asociado#&nbsp;:&nbsp;</strong></td>
        <td>
        	<cfif modocambio><cf_rhasociado idasociado="#rsForm.ACAid#" readonly="true"><cfelse><cf_rhasociado></cfif>
        </td>
      </tr>
      <tr>
        <td align="right" width="30%"><strong>#LB_Aporte#&nbsp;:&nbsp;</strong></td>
        <td>
        	<cfif modocambio>
	            <cfset vArrayAporte=ArrayNew(1)>
				<cfset ArrayAppend(vArrayAporte,rsForm.ACAAid)>
                <cfset ArrayAppend(vArrayAporte,rsForm.ACATcodigo)>
                <cfset ArrayAppend(vArrayAporte,rsForm.ACATdescripcion)>
			<cfelse><cfset vArrayAporte=ArrayNew(1)></cfif>
            <cf_conlis readonly="#modocambio#"
            	campos="ACAAid, ACATcodigo, ACATdescripcion"
                desplegables="N, S, S"
                modificables="N, S, N"
                size="0, 10, 40"
                valuesArray="#vArrayAporte#"
                title="#LB_Aportes_del_Asociado#"
                columnas="ACAAid, ACATcodigo, ACATdescripcion"
                tabla="ACAportesAsociado a 
                	inner join ACAportesTipo b
                    on b.ACATid = a.ACATid"
                filtro="ACAid = $ACAid,numeric$ and a.ACAestado = 0"
                desplegar="ACATcodigo, ACATdescripcion"
                etiquetas="#LB_Codigo#, #LB_Descripcion#"
                formatos="S,S"
                align="left, left"
                asignar="ACAAid, ACATcodigo, ACATdescripcion"
                asignarFormatos="S, S, S">
	    </td>
      </tr>
      <tr>
        <td align="right" width="30%"><strong>#LB_Periodo#&nbsp;:&nbsp;</strong></td>
        <td>#Lvar_mes#&nbsp;&nbsp;#Lvar_Periodo#</td>
      </tr>
      <tr>
        <td align="right" width="30%"><strong>#LB_Monto#&nbsp;:&nbsp;</strong></td>
        <td>
            <cfif modocambio><cf_monto name="ACARmonto" value="#rsForm.ACARmonto#"><cfelse><cf_monto name="ACARmonto"></cfif>
        </td>
      </tr>
      <tr>
        <td align="right" width="30%"><strong>#LB_Referencia#&nbsp;:&nbsp;</strong></td>
        <td>
            <cfif modocambio><input type="text" maxlength="60" name="ACARreferencia" value="#rsForm.ACARreferencia#">
			<cfelse><input type="text" maxlength="60" name="ACARreferencia"></cfif>
        </td>
      </tr>
    </table>
    <cfif modocambio><cf_botones modo="CAMBIO" include="Aplicar"><cfelse><cf_botones></cfif>
</form>
</cfoutput>
<cf_qforms>
	<cf_qformsrequiredfield args="ACAid,#LB_Asociado#">
    <cf_qformsrequiredfield args="ACAAid,#LB_Aporte#">
    <cf_qformsrequiredfield args="ACARmonto,#LB_Monto#">
    <cf_qformsrequiredfield args="ACARreferencia,#LB_Referencia#">
</cf_qforms>
<script language="javascript" type="text/javascript">
	function funcNuevo(){
		document.form1.ACARid.value = "";
		document.form1.action = "registroAportesManuales.cfm";
	}
</script>