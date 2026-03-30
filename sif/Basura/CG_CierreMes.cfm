<cfinclude template="../Application.cfm">
<cfinclude template="../Utiles/fnDateDiff.cfm">
<cfset session.debug = true>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<strong>EJECUTANDO LA FUNCION Cierre_Mes</strong><br>
<cfset timeinit = Now()>
Tiempo de Inicio:&nbsp; <cfoutput>#LSTimeFormat(timeinit,"hh:mm:ss:l")#</cfoutput><br>
<cfinvoke 
 component="sif.Componentes.Contabilidad"
 method="Cierre_Mes">
 <cfinvokeargument name="debug" value="true">
</cfinvoke>
<cfset timefin = Now()>
Tiempo de Finalización:&nbsp; <cfoutput>#LSTimeFormat(timefin,"hh:mm:ss:l")#</cfoutput><br>
Tiempo de ejecución en milisegundos:&nbsp; <cfoutput>#fnDateDiff('l',timeinit,timefin)#</cfoutput><br>

<strong>RETORNA:&nbsp;<cfoutput>##</cfoutput></strong><br>

<strong>TEXTO DEL SP</strong><br>

<table width="100%"  border="1" cellspacing="1" cellpadding="1">
  <tr>
    <td><p>if exists (select 1<br>
from sysobjects<br>
where id = object_id('CG_CierreMes')<br>
and type = 'P')<br>
drop procedure CG_CierreMes<br>
go</p>
      <p>&nbsp;</p>
      <p>create procedure CG_CierreMes<br>
  @Ecodigo int,<br>
  @debug char(1) = &quot;N&quot;<br>
  as<br>
  /*<br>
  ** Cierre de Mes de Contabilidad<br>
  ** Creado por: <br>
  ** Fecha:<br>
  */</p>
      <p>--Crear Tablas #INTARC, #asiento, #monedas, #polizas<br>
        declare <br>
  @Pcodigo_mes int,<br>
  @Pcodigo_per int,<br>
  @mes int,<br>
  @periodo int,<br>
  @sistema varchar(5),<br>
  @Pcodigo_aux_mes int,<br>
  @Pcodigo_aux_per int,<br>
  @sistema_aux varchar,<br>
  @mes_aux int,<br>
  @periodo_aux int,<br>
  @num_docs int,<br>
  @periodoant int,<br>
  @mesant int</p>
      <p>begin<br>-- valores iniciales, constantes etc. =]</p>
      <p>&lt;!---1---&gt;</p>
      <p>select <br>
  @Pcodigo_per = 30, <br>
  @Pcodigo_mes = 40, <br>
  @Pcodigo_aux_per = 50,<br>
  @Pcodigo_aux_mes = 60, <br>
  @sistema = &quot;CG&quot;, <br>
  @sistema_aux = 'GN'</p>
      <p>&lt;!---2---&gt;<br>
        -- Obtener los valores de Conta</p>
      <p>select @mes = convert(int, Pvalor)<br>
        from Parametros<br>
        where Pcodigo = @Pcodigo_mes <br>
  and Mcodigo = @sistema <br>
  and Ecodigo = @Ecodigo</p>
      <p>select @periodo = convert(int, Pvalor)<br>
        from Parametros<br>
        where Pcodigo = @Pcodigo_per <br>
  and Mcodigo = @sistema <br>and Ecodigo = @Ecodigo</p>
      <p>&lt;!---3---&gt;</p>
      <p>-- Obtener los valores de Auxiliares<br>
        select @mes_aux = convert(int, Pvalor)<br>
        from Parametros<br>
        where Pcodigo = @Pcodigo_aux_mes <br>
  and Mcodigo = @sistema_aux <br>
  and Ecodigo = @Ecodigo<br>
  select @periodo_aux = convert(int, Pvalor)<br>
  from Parametros<br>
  where Pcodigo = @Pcodigo_aux_per <br>
  and Mcodigo = @sistema_aux <br>
  and Ecodigo = @Ecodigo</p>
      <p>&lt;!---4---&gt;</p>
      <p>-- Validar si ya se realizo el cierre de Auxiliares<br>
        if ((@periodo_aux &lt; @periodo) or ((@periodo_aux = @periodo) and (@mes_aux &lt;= @mes)))<br>
        begin<br>
  raiserror 40000 &quot;Debe realizar el cierre de auxiliares, antes de realizar el cierre contable.&quot;<br>
  return -1<br>
  end</p>
      <p>&lt;!---5---&gt;</p>
      <p>-- validar si hay documentos sin Postear<br>
        select @num_docs = count(1)<br>
        from EContables<br>
        where Emes = @mes <br>
  and Eperiodo = @periodo <br>
  and Ecodigo = @Ecodigo</p>
      <p>if (@num_docs &gt; 0) begin<br>
  raiserror 40000 &quot;A&uacute;n existen documentos sin postear, para esta empresa, mes y periodo.&quot;<br>
  return -1<br>
  end</p>
      <p>&lt;!---6---&gt; </p>
      <p>select @periodoant = @periodo, @mesant = @mes</p>
      <p>-- actualizar el mes y periodo<br>
        select @mes = ((@mes % 12) + 1)<br>
        if (@mes = 1) begin<br>
  select @periodo = @periodo + 1<br>
  end </p>
      <p>&lt;!---7---&gt;</p>
      <p>begin tran</p>
      <p>--C&aacute;lculo de la Revaluaci&oacute;n<br>
        -- Copiar los datos del periodo actual al nuevo periodo<br>
        insert SaldosContables (Ecodigo, Ocodigo, Ccuenta, <br>
  Mcodigo, Speriodo, Smes, <br>
  SLinicial, DLdebitos, CLcreditos, <br>
  SOinicial, DOdebitos, COcreditos)<br>
  select Ecodigo, Ocodigo, Ccuenta, <br>
  Mcodigo, @periodo, @mes,<br>
  SLinicial + DLdebitos - CLcreditos, 0, 0,<br>
  SOinicial + DOdebitos - COcreditos, 0, 0<br>
  from SaldosContables<br>
  where Smes = @mesant <br>
  and Speriodo = @periodoant<br>
  and Ecodigo = @Ecodigo</p>
      <p>if (@@error != 0) begin<br>
  raiserror 40000 &quot;Error en actualizar datos de Saldos Contables&quot;<br>
  rollback tran<br>
  return -1<br>
  end</p>
      <p>--Actualizar el Periodo<br>
        update Parametros set Pvalor = convert(varchar(4), @periodo)<br>
        where Ecodigo = @Ecodigo<br>
  and Pcodigo = @Pcodigo_per<br>
  and Mcodigo = @sistema</p>
      <p>if ((@@error !=0) or (@@rowcount=0))<br>
        begin<br>
  raiserror 40000 &quot;Error! Se present&oacute; un error al intentar actualizar el per&iacute;odo Contable. Proceso Cancelado!&quot;<br>
  rollback tran<br>
  return -1<br>
  end</p>
      <p>--Actualizar el mes<br>
        update Parametros set Pvalor = convert(varchar(4), @mes)<br>
        where Ecodigo = @Ecodigo<br>
  and Pcodigo = @Pcodigo_mes<br>
  and Mcodigo = @sistema</p>
      <p>if ((@@error !=0) or (@@rowcount=0))<br>
        begin<br>
  raiserror 40000 &quot;Error! Se present&oacute; un error al intentar actualizar el mes Contable. Proceso Cancelado!&quot;<br>
  rollback tran<br>
  return -1<br>
  end</p>
      <p>if @debug=&quot;S&quot; <br>
        begin<br>
  select Parametros.Ecodigo, Parametros.Pcodigo, Parametros.Mcodigo, Parametros.Pdescripcion, Parametros.Pvalor, Parametros.ts_rversion from Parametros where Ecodigo = @Ecodigo and Pcodigo in (@Pcodigo_per, @Pcodigo_mes) and Mcodigo = @sistema<br>
  -- select * from #polizas<br>
  -- select * from #Monedas<br>
  -- select * from #INTARC<br>
  rollback tran<br>
  end<br>
  else<br>
  commit tran<br>
  end<br>
  go<br>
  exec sp_procxmode CG_CierreMes, anymode<br>
  go</p>    </td>
  </tr>
</table>
</body>
</html>
