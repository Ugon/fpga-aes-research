\NeedsTeXFormat{LaTeX2e} %
\ProvidesClass{aghthesis}

% DECLARING OPTIONS

\DeclareOption{polish}
{
\newcommand*{\LangAgh}{Akademia G\'{o}rniczo-Hutnicza\\[2mm] im. Stanis\l{}awa Staszica w Krakowie}
\newcommand*{\LangFaculty}{Wydzia{\l} Informatyki, Elektroniki i Telekomunikacji\\[2mm] Katedra Informatyki}
\newcommand*{\LangSupervisor}{Opiekun:}
\newcommand*{\LangStatementHead}{O\'SWIADCZENIE AUTORA PRACY}
\newcommand*{\LangStatementBody}{O\'swiadczam, \'swiadomy(-a) odpowiedzialno\'sci karnej za po\'swiadczenie nieprawdy, \.ze niniejszy projekt wykona{\l}em(-am) osobi\'scie i samodzielnie w zakresie opisanym w dalszej cz\k{e}\'sci dokumentu  i \.ze nie korzysta{\l}em(-am) ze \'zr\'ode{\l} innych ni\.z wymienione w dalszej cz\k{e}\'sci dokumentu.}
\newcommand*{\LangSignature}{PODPIS}
}

\DeclareOption{english}
{
\newcommand*{\LangAgh}{AGH University of Science and Technology}
\newcommand*{\LangFaculty}{Faculty of Computer Science, Electronics and Telecommunications\\[1mm] Department of Computer Science}
\newcommand*{\LangSupervisor}{Supervisor:}
\newcommand*{\LangStatementHead}{NON PLAGIARISM DECLARATION}
\newcommand*{\LangStatementBody}{Uprzedzony o~odpowiedzialno\'sci karnej na~podstawie art.~115 ust.~1~i~2 ustawy z~dnia 4~lutego 1994~r. o~prawie autorskim i~prawach pokrewnych (t.j. Dz.U. z~2006~r. Nr~90, poz.~631 z~p{\'o}{\'z}n. zm.): ,,Kto przyw\l{}aszcza sobie autorstwo albo~wprowadza w~b\l{}\k{a}d co~do~autorstwa ca\l{}o\'sci lub cz\k{e}\'sci cudzego utworu albo~artystycznego wykonania, podlega grzywnie, karze ograniczenia wolno\'sci albo~pozbawienia wolno\'sci do~lat~3. Tej~samej karze podlega, kto~rozpowszechnia bez~podania nazwiska lub~pseudonimu tw\'orcy cudzy utw\'or w~wersji oryginalnej albo~w~postaci opracowania, artystycznego wykonania albo~publicznie zniekszta\l{}ca taki utw\'or, artystyczne wykonanie, fonogram, wideogram lub nadanie.'', a~tak\.ze uprzedzony o~odpowiedzialno\'sci dyscyplinarnej na~podstawie art.~211 ust.~1 ustawy z~dnia 27~lipca 2005~r. Prawo o~szkolnictwie wy\.zszym (t.j. Dz.~U. z~2012~r. poz.~572, z~p\'o\'zn. zm.): ,,Za~naruszenie przepis\'ow obowi\k{a}zuj\k{a}cych w~uczelni oraz~za~czyny uchybiaj\k{a}ce godno\'sci studenta student ponosi odpowiedzialno\'s\'c dyscyplinarn\k{a} przed komisj\k{a} dyscyplinarn\k{a} albo~przed s\k{a}dem kole\.ze\'nskim samorz\k{a}du studenckiego, zwanym dalej <<s\k{a}dem kole\.ze\'nskim>>.'', o\'swiadczam, \.ze~niniejsz\k{a} prac\k{e} dyplomow\k{a} wykona\l{}em(-am) osobi\'scie i~samodzielnie i~\.ze~nie~korzysta\l{}em(-am) ze~\'zr\'ode\l{} innych ni\.z~wymienione w pracy.}
\newcommand*{\LangSignature}{SIGNATURE}
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}


% PROCESSING OPTIONS
\ProcessOptions
\LoadClass[a4paper,twoside]{article}


\RequirePackage{setspace}
\RequirePackage{times}
\RequirePackage[T1]{fontenc}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage[usenames]{color}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{babel}




\addto\captionspolish{%
  \def\bibname{Materia{\l}y {\'z}r{\'o}d{\l}owe}%
  \def\refname{Materia{\l}y {\'z}r{\'o}d{\l}owe}%
  \def\listtablename{Spis tabel}%
  \def\tablename{Tabela}%
}


\geometry{bindingoffset=10mm, lmargin=20mm, rmargin=20mm, tmargin=25mm, bmargin=25mm, foot=10mm, head=10mm}


\renewcommand{\baselinestretch}{1.1}

\def\thesistype#1   {\gdef\@thesistype{#1}}
\def\title#1        {\gdef\@title{#1}}
\def\titlepl#1     {\gdef\@titlepl{#1}}
\def\faculty#1      {\gdef\@faculty{#1}}
\def\thesistype#1   {\gdef\@thesistype{#1}}
\def\supervisor#1   {\gdef\@supervisor{#1}}

\bibliographystyle{abbrv}

%------------------------------------------------------------------------------


\renewcommand{\maketitle}{%


\newpage \titlepage

\begin{center}

{\Large{\bfseries{\textsc \LangAgh}}}

\vspace*{1mm}\rule{.9\textwidth}{1mm}\vspace*{1mm}

{\large \LangFaculty}\vspace*{0.5cm}

\includegraphics[width=100pt,viewport=250 350 350 500]{../common/agh.pdf}

\vspace*{1cm}
{\huge\scshape \@thesistype}\\
\vspace*{1.5cm}

%\begin{changemargin}{-0.7cm}{-0.7cm} 
\doublespacing
{\LARGE{\bfseries\scshape \@title}}\\
\vspace*{0.7cm}
%\end{changemargin}

{\large{\scshape \@titlepl}}\\
\vspace*{1.5cm}


{\LARGE\scshape \@author}\\
%\vspace*{5cm}
%\vfill

\vspace*{0.7cm}

\singlespacing

\large{\scshape Field of study:} {Information Technology}\\
\large{\scshape \LangSupervisor} {\@supervisor}
\vfill

\rule{.7\textwidth}{1mm}\\
\vspace*{1mm}
{\large Krak\'{o}w \@date}

\end{center}


\newpage
\thispagestyle{empty}

%\vspace*{15cm}
\mbox{}
\vfill

\begin{flushright}
\begin{minipage}[!h]{13cm}
\mbox{\large{\scshape \textbf{\LangStatementHead}}}\\[3mm]
{\footnotesize \scshape \LangStatementBody}\\
\end{minipage}

\vspace{2cm}

\makebox[6cm][s]{\dotfill}\par
\makebox[6cm][c]{\small \LangSignature}

\end{flushright}

%------------------------------------------------------------------------------

\clearpage
\setcounter{page}{3}

}

%\ProcessOptions

\pagestyle{fancy}
\renewcommand{\sectionmark}[1]{\markright{\thesection.\ #1}}
\renewcommand{\headrulewidth}{0.5pt}
\fancyhf{}
\fancyhead{}

\fancyhead[LE]{\bfseries \thepage}
\fancyhead[RO]{\bfseries \thepage}

\frenchspacing
\sloppy
\widowpenalty     9999
\clubpenalty      9999
\flushbottom




\titleformat{\section}[block]
{\bfseries\Large}{\filright \Large\thesection. }{0ex}{}
\titleformat{\subsection}[block]
{\bfseries\large}{\filright \large\thesubsection. }{0ex}{}
\titleformat{\subsubsection}[block]
{\bfseries\normalsize}{\filright \normalsize\thesubsubsection. }{0ex}{}
