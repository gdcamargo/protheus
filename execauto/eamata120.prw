//documenta?o: https://tdn.totvs.com/pages/releaseview.action?pageId=322152451

#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "tbiconn.CH"
User Function MyMata120()
Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nY := 0
Local cDoc := ""
Local lOk := .T.
Local cSeek := ""
Local nCount := 0
PRIVATE lMsErroAuto := .F.

PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SC7"
//????????????????????????????????
//| Abertura do ambiente |
//????????????????????????????????
ConOut(Repl("-",80))
ConOut(PadC("Teste de Inclusao de 10 pedidos de compra com 30 itens cada",80))
 
//????????????????????????????????
//| Verificacao do ambiente para teste |
//????????????????????????????????
dbSelectArea("SB1")
dbSetOrder(1)
If !SB1->(MsSeek(xFilial("SB1")+"PRD06          "))
    lOk := .F.
    ConOut("Cadastrar produto: PRD06          ")
EndIf
dbSelectArea("SF4")
dbSetOrder(1)
If !SF4->(MsSeek(xFilial("SF4")+"002"))
    lOk := .F.
    ConOut("Cadastrar TES: 002")
EndIf
dbSelectArea("SE4")
dbSetOrder(1)
If !SE4->(MsSeek(xFilial("SE4")+"001"))
    lOk := .F.
    ConOut("Cadastrar condicao de pagamento: 001")
EndIf
dbSelectArea("SA2")
dbSetOrder(1)
If !SA2->(MsSeek(xFilial("SA2")+"00123501"))
    lOk := .F.
    ConOut("Cadastrar fornecedor: 00123501")
EndIf
If lOk
    ConOut("Inicio: "+Time())
    //????????????????????????????????
    //| Verifica o ultimo documento valido para um fornecedor |
    //????????????????????????????????
    dbSelectArea("SC7")
    dbSetOrder(1)
    MsSeek(xFilial("SC7")+"zzzzzz",.T.)
    dbSkip(-1)
    cDoc := SC7->C7_NUM
    For nY := 1 To 1
        aCabec := {}
        aItens := {}
    If Empty(cDoc)
        cDoc := StrZero(1,Len(SC7->C7_NUM))
    Else
        cDoc := Soma1(cDoc)
    EndIf
    aadd(aCabec,{"C7_NUM" ,cDoc})
    aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
    aadd(aCabec,{"C7_FORNECE" ,"001235"})
    aadd(aCabec,{"C7_LOJA" ,"01"})
    aadd(aCabec,{"C7_COND" ,"001"})
    aadd(aCabec,{"C7_CONTATO" ,"AUTO"})
    aadd(aCabec,{"C7_FILENT" ,CriaVar("C7_FILENT")})
    cSeek:= xFilial("SC3")+"00123501"
    dbSelectArea("SC3")
    dbSetOrder(2)
    MsSeek(cSeek)
    While SC3->(!Eof()) .And. xFilial("SC3")+SC3->C3_FORNECE+SC3->C3_LOJA == cSeek
        aLinha := {}
        aadd(aLinha,{"C7_PRODUTO" ,SC3->C3_PRODUTO,Nil})
        aadd(aLinha,{"C7_QUANT" ,SC3->C3_QUANT ,Nil})
        aadd(aLinha,{"C7_PRECO" ,SC3->C3_PRECO ,Nil})
        aadd(aLinha,{"C7_TOTAL" ,SC3->C3_TOTAL ,Nil})
        aadd(aLinha,{"C7_NUMSC" ,SC3->C3_NUM ,Nil})
        aadd(aLinha,{"C7_ITEMSC" ,SC3->C3_ITEM ,Nil})
        aadd(aItens,aLinha)
        SC3->(dbSkip())
        nCount++
    Enddo
    //????????????????????????????????
    //| Teste de Inclusao |
    //????????????????????????????????
    If nCount > 0
    MATA120(2,aCabec,aItens,3)
    
        If !lMsErroAuto
            ConOut("Incluido com sucesso! "+cDoc)
        Else
            ConOut("Erro na inclusao!")
            MostraErro()
        EndIf
    Else
        ConOut("Autoriza?o n? incluida!")
    EndIF
    Next nY
    ConOut("Fim : "+Time())

EndIf
RESET ENVIRONMENT
Return(.T.)
