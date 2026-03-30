<body  bgcolor="#EEEEEE">
<cfsilent>
     <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Desea_eliminar_la_cita"
	Default="Desea eliminar la cita"
	returnvariable="MSG_Desea_eliminar_la_cita"/>
    
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_eliminar_la_cita"
	Default="Eliminar la cita"
	returnvariable="MSG_eliminar_la_cita"/>
     
     <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DO" Default="D" returnvariable="LB_DO"/> 
     <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_LU" Default="L" returnvariable="LB_LU"/> 
     <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MA" Default="K" returnvariable="LB_MA"/> 
     <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MI" Default="M" returnvariable="LB_MI"/> 
     <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_JU" Default="J" returnvariable="LB_JU"/> 
     <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_VI" Default="V" returnvariable="LB_VI"/> 
     <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SA" Default="S" returnvariable="LB_SA"/> 

    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ENE" Default="ENE" returnvariable="LB_ENE"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FEB" Default="FEB" returnvariable="LB_FEB"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MAR" Default="MAR" returnvariable="LB_MAR"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ABR" Default="ABR" returnvariable="LB_ABR"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MAY" Default="MAY" returnvariable="LB_MAY"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_JUN" Default="JUN" returnvariable="LB_JUN"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_JUL" Default="JUL" returnvariable="LB_JUL"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AGO" Default="AGO" returnvariable="LB_AGO"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SEP" Default="SEP" returnvariable="LB_SEP"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_OCT" Default="OCT" returnvariable="LB_OCT"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NOV" Default="NOV" returnvariable="LB_NOV"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DIC" Default="DIC" returnvariable="LB_DIC"/>
</cfsilent>                 

<cfparam name="Form.startdate" default="#dateformat(now()-5, 'dd/mm/yyyy')#">
<cfparam name="Form.enddate" default="#dateformat(now()-1, 'dd/mm/yyyy')#">
<cfparam name="Form.selectdate" default="#dateformat(now(), 'dd/mm/yyyy')#">


<cfform   name="formX" format="html" skin="haloBlue" width="163" height="150" >
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td valign="top"  align="center">
                <cfcalendar name="selectedDate"  
                selecteddate="#Form.selectdate#"
                mask="mmm dd, yyyy" 
                daynames="#LB_DO#,#LB_LU#,#LB_MA#,#LB_MI#,#LB_JU#,#LB_VI#,#LB_SA#"
                monthnames="#LB_ENE#,#LB_FEB#,#LB_MAR#,#LB_ABR#,#LB_MAY#,#LB_JUN#,#LB_JUL#,#LB_AGO#,#LB_SEP#,#LB_OCT#,#LB_NOV#,#LB_DIC#"
                style="rollOverColor:##FF0000"
                width="155" height="140">            
            </td>
        </tr>
    </table>
</cfform>    
                 
<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgenda = ComponenteAgenda.MiAgenda() >

<cfset varYYYY = DatePart("yyyy", now())>
<cfset varDD   = DatePart("d", now())>
<cfset varMM   = DatePart("m", now())>

<cfset Fechaini = CreateDateTime(varYYYY,varMM,varDD, '00', '00','00') >

<cfset FechaFin = CreateDateTime(varYYYY,varMM,varDD, '23', '59','59') >
                   
<cfquery datasource="asp" name="data" >
	select c.cita, c.fecha, c.inicio, c.final, 
		c.texto, c.url_link, c.origen, c.referencia,
		ac.agenda, ac.confirmada, ac.notificar, ac.eliminada, ac.CEcodigo,
		case	when ac.confirmada = 0 then 0
				when exists (select * from ORGAgendaCita ot
					where ot.cita = ac.cita
					  and ot.CEcodigo = ac.CEcodigo
					  and ot.confirmada = 0)
					then 0
				else 1 end as TodosVan,
		case	when ac.eliminada = 1 then 1
				when exists (select * from ORGAgendaCita ot
					where ot.cita = ac.cita
					  and ot.CEcodigo = ac.CEcodigo
					  and ot.eliminada = 1)
					then 1
				else 0 end as AlguienElimino
	from ORGAgendaCita ac, ORGCita c
	where ac.agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CodigoAgenda#">
	  and ac.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and c.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and c.cita      = ac.cita
	order by c.inicio, ac.agenda
</cfquery>

<cfquery  dbtype="query" name="data1" >
	select  fecha,inicio,texto,cita,agenda,CEcodigo from data
    where fecha  between  <cfqueryparam cfsqltype="cf_sql_timestamp"    value="#Fechaini#"> 
    and  <cfqueryparam cfsqltype="cf_sql_timestamp"    value="#FechaFin#">
</cfquery>

<cfquery  dbtype="query" name="data2" >
	select  fecha,inicio,texto,cita,agenda,CEcodigo from data
    where fecha >  <cfqueryparam cfsqltype="cf_sql_timestamp"    value="#Fechaini#"> 
    order by fecha
</cfquery>

<cfquery  dbtype="query" name="data3" >
	select  fecha,inicio,texto,cita,agenda,CEcodigo from data
    where fecha <  <cfqueryparam cfsqltype="cf_sql_timestamp"    value="#Fechaini#"> 
    order by fecha desc
</cfquery>
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
<table  bgcolor="#FFFFFF" width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
<tr>
    <td   valign="middle" align="center" colspan="3"  class="RLTtopline" >
        <font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px"><b>
        <cf_translate  key="LB_MiAgenda">Mi Agenda</cf_translate></b></font>
        &nbsp;<img  style="cursor:pointer" onClick="Javascript:fn_calendario();" border="0" src="/cfmx/rh/imagenes/cal.gif">
    </td>
    <!--- <td  align="right" colspan="2"  class="RLTtopline">
    	<img border="0" src="/cfmx/rh/imagenes/cal.gif" >
    </td> --->

</tr>
<tr>
    <td   width="28%"  align="left" class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px"><b>
    <cf_translate  key="LB_Fecha">Fecha</cf_translate></b></font></td>
    <td  align="left" colspan="2" class="RLTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px"><b><cf_translate  key="LB_Asunto">Asunto</cf_translate></b></font></td>
</tr>
</table>

<cfset corte = "">
<div align="center" style=" width:200px; height:220px; overflow:auto; " >
	
    <table   bgcolor="#FFFFFF" width="100%" border="0" cellspacing="0" cellpadding="1">
        <cfoutput>
            <cfif data1.recordCount GT 0>
                <cfloop query="data1">
                <cfif corte neq  data1.fecha>
                    <cfset corte = data1.fecha>
                    <tr>
                        <td    bgcolor="##CCCCCC" colspan="3" align="left"  class="RLTtopline" ><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px"><b><cf_translate  key="LB_Hoy">HOY</cf_translate></b></font></td>
                    </tr>
                </cfif> 
                    <tr>
                        <td      valign="bottom" nowrap align="left"  class="LTtopline" ><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px">#LSTimeFormat(data1.inicio,'hh:mm tt')#</font></td>
                        <td   width="79%" valign="bottom" align="left"  class="LTtopline" ><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px">#trim(data1.texto)# </font></td>
                        <td  width="1%" valign="middle" align="left"   class="RLTtopline" style="cursor:pointer" ><img  onClick="Javascript:Eliminar(#data1.cita#,#data1.agenda#,#data1.CEcodigo#)" height="10px" width="10px" src="/cfmx/rh/imagenes/Borrar01_S.gif"></td>
                    </tr>    
                </cfloop>
            </cfif>
            <cfif data2.recordCount GT 0>
                <cfloop query="data2">
                <cfif corte neq  data2.fecha>
                    <cfset corte = data2.fecha>
                    <tr>
                        <td     bgcolor="##CCCCCC" colspan="3" align="left"  class="RLTtopline" ><b><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px">#LSDateFormat(data2.fecha, "dd/mm/yyyy")#</font></b></td>
                    </tr>
                </cfif> 
                    <tr>
                        <td    valign="bottom" nowrap  align="left"  class="LTtopline" ><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px">#LSTimeFormat(data2.inicio,'hh:mm tt')#</font></td>
                        <td   width="79%" valign="bottom" align="left"  class="LTtopline" ><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px">#trim(data2.texto)# </font></td>
                        <td   width="1%" valign="middle" align="left"   class="RLTtopline" style="cursor:pointer"><img  onClick="Javascript:Eliminar(#data2.cita#,#data2.agenda#,#data2.CEcodigo#)" height="10px" width="10px" src="/cfmx/rh/imagenes/Borrar01_S.gif"></td>
                    </tr>    
                </cfloop>
            </cfif>
            <cfif data3.recordCount GT 0>
                <tr>
                	<td colspan="3" align="center"  class="RLTtopline" ><b><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px"><cf_translate  key="LB_Anteriores">Anteriores</cf_translate></font></b></td>
                </tr>
                <cfloop query="data3">
                <cfif corte neq  data3.fecha>
                    <cfset corte = data3.fecha>
                    <tr>
                        <td     bgcolor="##CCCCCC" colspan="3" align="left"  class="RLTtopline" ><b><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px">#LSDateFormat(data3.fecha, "dd/mm/yyyy")#</font></b></td>
                    </tr>
                </cfif> 
                    <tr>
                        <td    valign="bottom" nowrap  align="left"  class="LTtopline" ><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px">#LSTimeFormat(data3.inicio,'hh:mm tt')#</font></td>
                        <td   width="79%" valign="bottom" align="left"  class="LTtopline" ><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px">#trim(data3.texto)# </font></td>
                        <td   width="1%" valign="middle" align="left"   class="RLTtopline" style="cursor:pointer" ><img  onClick="Javascript:Eliminar(#data3.cita#,#data3.agenda#,#data3.CEcodigo#)" height="10px" width="10px" src="/cfmx/rh/imagenes/Borrar01_S.gif"></td>
                    </tr>    
                </cfloop>
            </cfif>            
        </cfoutput>
        
        
        <tr>
          <td  bgcolor="#EEEEEE" colspan="3"  class="topline" ><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:8px">&nbsp;</font></td>
        </tr>    
    </table>  
</div>
<form style="margin:0" action="SQL_Calendario.cfm" method="post" name="listacalendar" id="listacalendar" >
	<input type="hidden" name="cita" 	  value="">
	<input type="hidden" name="agenda"    value="">
    <input type="hidden" name="CEcodigo"  value="">
    <input type="hidden" name="ACCION"    value="">
</form>
<script type="text/javascript">

	function Eliminar(cita, agenda, CEcodigo){
		 if (confirm('¿<cfoutput>#MSG_Desea_eliminar_la_cita#</cfoutput>?')){
			document.listacalendar.cita.value 		= cita;
			document.listacalendar.agenda.value 	= agenda;
			document.listacalendar.CEcodigo.value 	= CEcodigo;
			document.listacalendar.ACCION.value 	= 'DELETE';
			document.listacalendar.submit();
		}
	}
	 function fn_calendario(){
		
		var fecha = '<cfoutput>#LSDateFormat(Now(), "dd/mm/yyyy")#</cfoutput>';
		
		var PARAM  = "/cfmx/home/menu/portlets/agenda/agenda.cfm?AUTO=S&fecha="+ fecha
		open(PARAM,'AGENDA','left=100,top=150,toolbar =no,scrollbars=no,resizable=no,width=970,height=450')
	} 
</script>
