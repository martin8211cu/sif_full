<cf_dbfunction name="to_number" args="v.VSvalor" returnVariable="VSvalorNumber">
<cfinvoke 
    Component="rh.Componentes.pListas"
    method="pListaRH"
    columnas="b.ACAid, b.ACAAid, a.ACASperiodo, VSdesc as ACASmes, a.ACAAsaldoInicial, a.ACAAaporteMes, a.ACAAsaldoInicialInt, a.ACAAaporteMesInt, 
                (a.ACAAsaldoInicial + a.ACAAaporteMes) as ACAAsaldoFinal, (a.ACAAsaldoInicialInt + a.ACAAaporteMesInt) as ACAAsaldoFinalInt"
    desplegar="ACASperiodo, ACASmes, ACAAsaldoInicial, ACAAaporteMes, ACAAsaldoFinal, ACAAsaldoInicialInt, ACAAaporteMesInt, ACAAsaldoFinalInt"
    etiquetas="#LB_Periodo#, #LB_Mes#, #LB_Saldo_Inicial#, #LB_Aporte_Mes#, #LB_Saldo_Final#, #LB_Saldo_Inicial_Intereses#, #LB_Interes_Mes#, #LB_Saldo_Final_Intereses#"
    align="left, left, right, right, right, right, right, right"
    formatos="S, S, M, M, M, M, M, M"
    tabla="ACAportesSaldos a
        inner join ACAportesAsociado b
        on b.ACAAid=a.ACAAid
        inner join Idiomas i
        on Icodigo = '#session.idioma#'
        inner join VSidioma v
        on v.Iid = i.Iid
        and v.VSgrupo = 1
        and #VSvalorNumber# = a.ACASmes"
    filtro="a.ACAAid = #form.ACAAid# order by a.ACASperiodo, a.ACASmes"
    irA="registroCuentasAhorro.cfm"
    showLink="false"
    maxrows="20"
    maxrowsquery="400"
    navegacion="ACAAid=#form.ACAAid#"
    showEmptyListMsg="true"
/>