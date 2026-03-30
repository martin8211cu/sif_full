<cfsilent>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Concepto_Incidente"
		Default="Concepto Incidente"
		XmlFile="/rh/generales.xml"
		returnvariable="vConcepto"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Descripcion"
		Default="Descripci&oacute;n"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_Descripcion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ListaDeIncidencias"
		Default="Lista de Incidencias"
		returnvariable="LB_ListaDeIncidencias"/>
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Filtrar"
		Default="Filtrar"
		XmlFile="/rh/generales.xml"
		returnvariable="vFiltrar"/>	
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Modificar_la_Fecha"
		Default="Modificar la Fecha"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_Modificar_la_Fecha"/>	
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Cancelar"
		Default="Cancelar"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_Cancelar"/>	        
        
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Eliminar"
		Default="Eliminar"
		XmlFile="/rh/generales.xml"
		returnvariable="vEliminar"/>	
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Limpiar"
		Default="Limpiar"
		XmlFile="/rh/generales.xml"
		returnvariable="vLimpiar"/>	 
	<cfinvoke component="sif.Componentes.Translate"
         method="Translate"
         Key="LB_NoSeEncontraronRegistros"
         Default="No se encontraron Registros "
         returnvariable="LB_NoSeEncontraronRegistros"/>   
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Fecha"
        Default="Fecha"
        XmlFile="/rh/generales.xml"
        returnvariable="vFecha"/> 
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="Concepto_Incidente"
        Default="Concepto Incidente"
        XmlFile="/rh/generales.xml"
        returnvariable="vConcepto"/> 
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Empleado"
        Default="Empleado"
        XmlFile="/rh/generales.xml"
        returnvariable="vEmpleado"/>  
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Cantidad_Monto"
        Default="Cantidad/Monto"
        returnvariable="vCantidadMonto"/> 
<cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Incidencias_pendientes_de_pagar"
        Default="Incidencias pendientes de pagar"
        returnvariable="LB_Incidencias_pendientes_de_pagar"/>                                      
</cfsilent>
<cfset navegacion = "" >
 <cf_dbfunction name="to_char" args="Iid" returnvariable="Lvar_to_char_Iid">

<cfset vConcatenador = '+'>
 <cfif isdefined("Application.dsinfo") and trim(lcase(Application.dsinfo[session.dsn].type)) eq 'oracle'>
 	<cfset vConcatenador = '||'>
 </cfif>

<cfquery name="rsLista" datasource="#Session.DSN#">		
    select 
        i.Iid,
        c.CIcodigo,
        c.CIdescripcion, 
        i.Ifecha,
        i.Ivalor,
        case c.CItipo  	when 0 then  '<cf_translate  key="LB_Horas">Hora(s)</cf_translate>' 
                        when 1 then  '<cf_translate  key="LB_Dias">D&iacute;a(s)</cf_translate>'
        						else '<cf_translate  key="LB_Monto">Monto(s)</cf_translate>' 
        end as tipo_Ivalor,
        {fn concat({fn concat({fn concat({fn concat({fn concat({fn concat(d.DEidentificacion ,' ' )} ,d.DEnombre )},' ')},d.DEapellido1 )}, ' ' )},d.DEapellido2 )}  as NombreEmp,
        '<a href="javascript: Eliminar(''' #vConcatenador# #Lvar_to_char_Iid# #vConcatenador# ''');"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>'  as borrar,
        '<a href="javascript: Editar(''' #vConcatenador# #Lvar_to_char_Iid# #vConcatenador# ''');"><img src=''/cfmx/rh/imagenes/cal.gif'' border=''0''></a>'  as editar,
		( select distinct RHTdesc  
          from DLaboralesEmpleado a, RHTipoAccion b 
          where a.DEid = i.DEid 
              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
              and i.Ifecha between a.DLfvigencia and a.DLffin
              and a.RHTid = b.RHTid 
              and b.RHTnopagaincidencias = 1) as tipoaccion        
        
    from Incidencias i
    inner join  CIncidentes c
        on i.CIid = c.CIid
        and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
    inner join DatosEmpleado d
        on i.DEid  = d.DEid 	
          where exists ( 
                select 1  
                from LineaTiempo a
                	inner join RHTipoAccion b
                    on b.RHTid = a.RHTid
					<cfif isdefined("url.RHTid") and len(trim(url.RHTid))>
						and a.RHTid = <cfqueryparam value="#url.RHTid#" cfsqltype="cf_sql_numeric">
					</cfif>
                where a.DEid = i.DEid 
                  and i.Ifecha between a.LTdesde and a.LThasta
                  and b.RHTnopagaincidencias = 1)  <!---No incluir conceptos de pago incidentes entre las fechas de vigencia de la acción --->
    <cfif isdefined("url.Ifecha") and len(trim(url.Ifecha))>
        and i.Ifecha >= <cfqueryparam value="#url.Ifecha#" cfsqltype="cf_sql_timestamp">
    </cfif>
    <cfif isdefined("url.DEid") and len(trim(url.DEid))>
        and i.DEid = <cfqueryparam value="#url.DEid#" cfsqltype="cf_sql_numeric">
    </cfif>
    <cfif isdefined("url.CIid") and len(trim(url.CIid))>
        and i.CIid = <cfqueryparam value="#url.CIid#" cfsqltype="cf_sql_numeric">
    </cfif>          
    order by 7,10,4
</cfquery>	

<cfif rsLista.recordCount GT 0>
    <cfoutput>
	<cfif not isdefined("form.btnDownload")>
        <cf_templatecss>
    </cfif>					
    <cfset LvarFileName = "Incidencias_pendientes_de_pagar_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
    <cf_htmlReportsHeaders 
        title="#LB_Incidencias_pendientes_de_pagar#" 
        filename="#LvarFileName#"
        back="no"
        irA="ListIncNoPagadas.cfm" 
        >
    </cfoutput>   
    <style type="text/css">
    
        
        .RLTtopline {
            border-bottom-width: none;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-top-width: 1px;
            border-top-style: solid;
            border-top-color: #000000			
        }	
        
        .LTtopline {
            border-bottom-width: none;
            border-bottom-width: none;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-top-width: 1px;
            border-top-style: solid;
            border-top-color: #000000			
        }	
        .LRTtopline {
            border-bottom-width: none;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-top-width: 1px;
            border-top-style: solid;
            border-top-color: #000000			
        }
        
        .RTtopline {
            border-bottom-width: none;
            border-bottom-width: none;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-top-width: 1px;
            border-top-style: solid;
            border-top-color: #000000			
        }	
        
        .Completoline {
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: #000000;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-top-width: 1px;
            border-top-style: solid;
            border-top-color: #000000			
        }	
        
        .topline {
                border-top-width: 1px;
                border-top-style: solid;
                border-top-color: #000000;
                border-right-style: none;
                border-bottom-style: none;
                border-left-style: none;
            }
        
        .bottonline {
                border-bottom-width: 1px;
                border-bottom-style: solid;
                border-bottom-color: #000000;
                border-right-style: none;
                border-top-style: none;
                border-left-style: none;
            }
            
        .RLTbottomline {
            border-top-width: none;
            border-left-width: none;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: #000000			
        }	
        
        .RLTbottomline2 {
            border-top-width: none;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: #000000			
        }
        
        .RLline {
            border-top-width: none;
            border-bottom-width: none;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
        }
        
        .LTbottomline {
            border-top-width: none;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: #000000			
        }		
            
    </style>
    <cfset empleado = "">
    <cfset accion  = "">
    <cfoutput>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr bgcolor="##CCCCCC">
            <td  align="center" nowrap="nowrap" width="7%"><font  style="font-size:11px"><b><cf_translate  key="LB_Empleado">Empleado</cf_translate></b></font></td>
            <td  align="center" nowrap="nowrap" width="4%"><font  style="font-size:11px"><b>
          <cf_translate  key="LB_Accion">Acci&oacute;n</cf_translate></b></font></td>
            <td  align="center" width="9%"><font  style="font-size:11px"><b>
          <cf_translate  key="LB_Fecha">Fecha</cf_translate></b></font></td>
            <td  width="39%"><font  style="font-size:11px"><b>
          <cf_translate  key="LB_Concepto">Concepto</cf_translate></b></font></td>
            <td  align="center" colspan="2"><font  style="font-size:11px"><b>
          <cf_translate  key="LB_Concepto">Cantidad/Monto</cf_translate></b></font></td>
            <cfif not isdefined("form.btnDownload")><td  colspan="2"  align="center">&nbsp;</td>
            </cfif>
        </tr>	
        
        <cfloop query="rsLista">
            <cfset LvarListaNon = (rsLista.CurrentRow MOD 2)>
            <cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
            <cfif trim(rsLista.NombreEmp) neq trim(empleado)>
                <cfset empleado = trim(rsLista.NombreEmp)>
                <cfset accion  = "">
                <tr>
                    <td  colspan="<cfif not isdefined("form.btnDownload")>8<cfelse>6</cfif>"><font  style="font-size:12px">&nbsp;</font></td>
                </tr>            
                <tr bgcolor="##CCCCCC">
                    <td  colspan="<cfif not isdefined("form.btnDownload")>8<cfelse>6</cfif>"><font  style="font-size:12px">&nbsp;#trim(empleado)#</font></td>
                </tr>
            </cfif>
            <cfif trim(rsLista.tipoaccion) neq trim(accion)>
                <cfset accion  = trim(rsLista.tipoaccion)>
                <tr>
                    <td >&nbsp;</td>
                    <td  colspan="<cfif not isdefined("form.btnDownload")>7<cfelse>5</cfif>"><font  style="font-size:12px">&nbsp;#trim(accion)#</font></td>
                </tr>
            </cfif>
            <cfif not isdefined("form.btnDownload")>
                <tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';"> 
            <cfelse>
                <tr>
            </cfif>
                <td >&nbsp;</td>
                <td >&nbsp;</td>
                <td  align="center"><font  style="font-size:11px">#LSDateFormat(rsLista.Ifecha, "dd/mm/yyyy")#</font></td>
                <td  align="left"><font  style="font-size:11px">#trim(rsLista.CIcodigo)#-#trim(rsLista.CIdescripcion)#</font></td>
                <td  width="5%"  nowrap="nowrap" align="center"><font  style="font-size:11px">#trim(rsLista.tipo_Ivalor)#</font></td>
                <td  width="5%" align="right"><font  style="font-size:11px">#LSNumberFormat(rsLista.Ivalor,',.00')#</font></td>
          		<cfif not isdefined("form.btnDownload")>
                    <td width="5%"  align="center">#trim(rsLista.borrar)#</td>
                	<td width="5%"  align="center">#trim(rsLista.editar)#</td>
              	</cfif>
            </tr>
        </cfloop>
        <tr>
            <td  colspan="<cfif not isdefined("form.btnDownload")>8<cfelse>6</cfif>"><font  style="font-size:12px">&nbsp;</font></td>
        </tr>
    </table>
    </cfoutput>
<cfelse>
	<cfoutput>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td align="center">&nbsp;</td>
        </tr>
        <tr>
            <td align="center"><font  style="font-size:20px"><cf_translate  key="LB_La_consulta_no_retorno_informacion">La consulta no retorno informaci&oacute;n</cf_translate></font></td>
        </tr>
    </table>
    </cfoutput>
</cfif>

<cfif rsLista.recordCount GT 0>
   <cfoutput>
   <form name="form1" method="post" action="IncNoPagadas-sql.cfm">
        <input type="hidden" name="Iid" value="">
        <input type="hidden" name="accion" value="">
		<cfif isdefined("url.RHTid") and len(trim(url.RHTid))>
            <input type="hidden" name="RHTid" value="#url.RHTid#">
        </cfif>
        <cfif isdefined("url.Ifecha") and len(trim(url.Ifecha))>
            <input type="hidden" name="Ifecha" value="#url.Ifecha#">
        </cfif>
        <cfif isdefined("url.DEid") and len(trim(url.DEid))>
            <input type="hidden" name="DEid" value="#url.DEid#">
        </cfif>
        <cfif isdefined("url.CIid") and len(trim(url.CIid))>
            <input type="hidden" name="CIid" value="#url.CIid#">
        </cfif>          
    </form>    
    </cfoutput>
    <script language="JavaScript">
		function Eliminar(id){
			document.form1.action='IncNoPagadas-sql.cfm';
			document.form1.accion.value='DEL';
			document.form1.Iid.value=id;
			document.form1.submit();
		}
		
		function Editar(id){
			var params  = "EditIncNoPagadas.cfm?Iid="+ id
			<cfif isdefined("url.RHTid") and len(trim(url.RHTid))>
				params = params + "&RHTid=<cfoutput>#url.RHTid#</cfoutput>";
			</cfif>
			<cfif isdefined("url.Ifecha") and len(trim(url.Ifecha))>
				params = params + "&IfechaF=<cfoutput>#url.Ifecha#</cfoutput>";
			</cfif>
			<cfif isdefined("url.DEid") and len(trim(url.DEid))>
				params = params + "&DEid=<cfoutput>#url.DEid#</cfoutput>";
			</cfif>
			<cfif isdefined("url.CIid") and len(trim(url.CIid))>
				params = params + "&CIid=<cfoutput>#url.CIid#</cfoutput>";
			</cfif>  
			x = open(params,'Edit','left=300,top=300,scrollbars=yes,resizable=yes,width=500,height=300');
			x.focus();
		}		
	</script>
</cfif>





			 	
