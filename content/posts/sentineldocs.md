---
title: "SentinelDocs: A Privacy-First AI Document Analyst"
date: 2025-04-07T10:30:00+00:00
tags: ["AI", "Privacy", "Python", "Document Analysis", "LLM"]
draft: true
description: "Building a completely offline AI document analysis tool that respects privacy"
ShowReadingTime: true
---

## The Privacy Challenge in Document Analysis

In the age of AI-powered tools, document analysis has been revolutionized by large language models. However, most solutions require uploading sensitive documents to cloud services, creating significant privacy concerns for professionals working with confidential information.

This privacy challenge is particularly acute for:

- **Legal professionals** handling confidential client documents
- **Healthcare providers** working with protected health information
- **Financial analysts** reviewing sensitive financial records
- **Researchers** working with unpublished or proprietary data
- **Business consultants** analyzing confidential client information

While cloud-based AI tools offer impressive capabilities, they often come with unacceptable privacy trade-offs for these use cases. This gap between powerful AI analysis and privacy requirements led me to develop SentinelDocs.

## Introducing SentinelDocs

SentinelDocs is an offline, privacy-first AI document assistant that runs entirely on your local machine. It leverages locally-hosted large language models through Ollama to provide powerful document analysis capabilities without any data ever leaving your computer.

![SentinelDocs Interface](/images/sentineldocs-ui.png)

The core architecture combines several key technologies:

1. **Document Processing Pipeline**: Extracts text from multiple document formats
2. **Vector Indexing with FAISS**: Creates searchable semantic indexes
3. **Natural Language Processing**: Uses spaCy for entity recognition and analysis
4. **Local LLM Integration**: Connects to models running in Ollama
5. **Streamlit UI**: Provides an intuitive user interface

## Technologies Powering SentinelDocs

SentinelDocs leverages a carefully selected stack of open-source technologies to provide robust document analysis capabilities while maintaining privacy:

### Core AI Technologies

- **Ollama**: The foundation of SentinelDocs' privacy-first approach, Ollama allows running powerful LLMs like DeepSeek, Mistral, and Llama locally without data leaving your machine. It provides a simple API for model management and inference.

- **LangChain**: Used for building the document processing pipeline and managing the flow of information between components. LangChain provides the framework for document loading, chunking, embedding, and retrieval.

- **FAISS (Facebook AI Similarity Search)**: The vector database behind SentinelDocs' semantic search capabilities. FAISS enables efficient similarity search over document embeddings, even with large collections, through optimized indexing techniques.

- **Sentence Transformers**: Provides the embedding models that convert text into vector representations, enabling semantic search and similarity comparisons. SentinelDocs uses the `all-MiniLM-L6-v2` model optimized for document similarity.

- **spaCy**: Powers the natural language processing features, including named entity recognition, part-of-speech tagging, and syntactic analysis. SentinelDocs uses the `en_core_web_sm` model for efficient document processing.

### Document Processing 

- **PyPDF2**: Handles PDF document extraction with capabilities for parsing text, metadata, and structure from complex PDF files.

- **python-docx**: Provides DOCX file parsing for accurate extraction of text, tables, and formatting from Microsoft Word documents.

- **langchain_text_splitters**: Used for intelligently chunking documents into semantically coherent sections while respecting natural boundaries like paragraphs and sections.

### Web Interface and Visualization

- **Streamlit**: Creates the responsive web interface with minimal boilerplate code. Streamlit's data-centric approach allows for rapid development of interactive components.

- **Plotly**: Generates interactive data visualizations for document statistics, entity distributions, and topic analysis.

- **ReportLab**: Powers the PDF report generation capability, allowing users to export comprehensive document analyses.

### Performance Optimization

- **NumPy**: Provides efficient numerical operations for vector manipulations and similarity calculations.

- **Joblib**: Enables parallel processing for computationally intensive tasks like document embedding and analysis.

- **LRU Cache**: Implements intelligent caching to avoid redundant processing of documents and queries.

## Key Features

SentinelDocs offers a comprehensive set of document analysis capabilities:

### 📂 Multi-format Document Support
The system can process and analyze PDFs, DOCX, and TXT files with a simple drag-and-drop interface.

### 🔍 AI-Powered Semantic Search
Ask questions about your documents in natural language and get precise answers based on document content.

```python
# Example of semantic search implementation
def semantic_search(query, document_embeddings, documents, top_k=3):
    """Perform semantic search on document embeddings."""
    query_embedding = model.encode([query])[0]
    query_embedding = query_embedding / np.linalg.norm(query_embedding)
    
    # Search for similar document chunks
    scores, indices = document_embeddings.search(
        np.array([query_embedding]), top_k
    )
    
    return [documents[idx] for idx in indices[0]]
```

### 📊 Document Statistics
Get comprehensive statistics and insights about your documents, including:
- Word count and reading time
- Key topics and themes
- Entity recognition (people, organizations, locations)
- Document complexity metrics

### 📋 Entity Recognition
Automatically identify and extract key entities from your documents:

```python
# Entity extraction example
def extract_entities(text):
    """Extract named entities from text using spaCy."""
    doc = nlp(text)
    entities = {
        "PERSON": [],
        "ORG": [],
        "GPE": [],  # Countries, cities, states
        "DATE": [],
        "MONEY": [],
    }
    
    for ent in doc.ents:
        if ent.label_ in entities:
            entities[ent.label_].append(ent.text)
            
    return entities
```

### 📑 Cross-Document Comparison
Compare multiple documents to identify similarities, differences, and relationships between them.

### 📄 PDF Report Generation
Export comprehensive document analyses as professional PDF reports with charts and visualizations.

## The Technical Architecture

SentinelDocs is built with Python and integrates several powerful libraries:

```python
# Core components and their roles
import streamlit as st  # Web interface
from langchain_community.llms import Ollama  # Local LLM connection
import faiss  # Vector similarity search
import spacy  # Natural language processing
from sentence_transformers import SentenceTransformer  # Document embeddings
from PyPDF2 import PdfReader  # PDF processing
import docx  # DOCX processing
from langchain_text_splitters import RecursiveCharacterTextSplitter  # Document chunking
import numpy as np  # Numerical operations
import plotly.express as px  # Data visualization
from reportlab.pdfgen import canvas  # PDF generation
from functools import lru_cache  # Performance optimization
```

The system follows a modular architecture:

![SentinelDocs Architecture](/images/sentineldocs-architecture.png)

### Document Processing Flow

1. **Document Ingestion**: Files are uploaded and text is extracted based on format
2. **Chunking**: Documents are divided into manageable sections
3. **Embedding**: Chunks are embedded using Sentence Transformers
4. **Indexing**: Embeddings are stored in a FAISS index for efficient retrieval
5. **Analysis**: Various NLP analyses are performed on the text
6. **Query Processing**: User questions are embedded and used to retrieve relevant content
7. **Response Generation**: The LLM generates answers based on retrieved context

## Technical Implementation Details

The heart of SentinelDocs is its retrieval-augmented generation (RAG) system. Here's a closer look at the implementation:

### Document Chunking Strategy

```python
def chunk_document(text, chunk_size=1000, chunk_overlap=200):
    """Split document into chunks with overlap for context preservation."""
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
        length_function=len,
        separators=["\n\n", "\n", ". ", " ", ""]
    )
    return text_splitter.split_text(text)
```

The chunking strategy is critical for maintaining context while respecting the context window limitations of local LLMs. SentinelDocs uses a recursive approach that tries to split on natural boundaries.

### Vector Database Creation

```python
def create_vector_store(chunks, embedding_model):
    """Create a FAISS vector store from document chunks."""
    # Generate embeddings for all chunks
    embeddings = embedding_model.encode(chunks)
    
    # Normalize the embeddings
    embeddings = embeddings / np.linalg.norm(embeddings, axis=1, keepdims=True)
    
    # Create the FAISS index
    dimension = embeddings.shape[1]
    index = faiss.IndexFlatL2(dimension)
    index.add(embeddings.astype('float32'))
    
    return index
```

The vector database is implemented using FAISS's `IndexFlatL2` for exact nearest neighbor search, which provides the most accurate retrieval results. For larger document collections, SentinelDocs can switch to approximate nearest neighbor algorithms like HNSW for better performance.

### Query Processing Pipeline

```python
def process_query(query, index, chunks, embedding_model, llm):
    """Process a user query to generate a response based on document content."""
    # Embed the query
    query_embedding = embedding_model.encode([query])[0]
    query_embedding = query_embedding / np.linalg.norm(query_embedding)
    
    # Search for similar chunks
    k = 3  # Number of chunks to retrieve
    distances, indices = index.search(np.array([query_embedding], dtype='float32'), k)
    
    # Create the context from retrieved chunks
    context = "\n\n".join([chunks[i] for i in indices[0]])
    
    # Generate the response using the LLM
    prompt = f"""
    Context information:
    {context}
    
    Question: {query}
    
    Based on the context information provided above, answer the question concisely.
    """
    
    return llm(prompt)
```

The query processing pipeline combines vector similarity search with prompt engineering to guide the LLM in generating accurate responses based on document content.

## Privacy-First Design Philosophy

SentinelDocs was built with privacy as the core design principle:

- **100% Local Processing**: All AI analysis happens on your machine
- **Zero Data Sharing**: No document data is ever sent to external servers
- **No Telemetry**: No usage data is collected or transmitted
- **Offline Operation**: After initial setup, internet connection is not required

This approach ensures that sensitive document data remains under your complete control at all times.

## Model Selection and Performance

I tested SentinelDocs with various local LLMs to find the optimal balance of performance and resource requirements:

| Model | Performance | Resource Usage | Best For |
|-------|-------------|----------------|----------|
| DeepSeek-R1 (8B) | Excellent | Moderate | General document analysis |
| Mistral (7B) | Good | Low-Moderate | Quick analysis of smaller documents |
| Llama 3 (8B) | Very Good | Moderate-High | Complex reasoning tasks |

DeepSeek-R1 emerged as the overall best performer for document analysis tasks, offering excellent comprehension and response quality with reasonable resource requirements.

## Performance Benchmarks

I conducted benchmarks on document processing and query response times using a dataset of 100 legal documents (average 15 pages each):

| Operation | Average Time | Optimization Used |
|-----------|--------------|------------------|
| Document Loading | 2.3s per document | Parallel processing |
| Embedding Generation | 5.1s per document | Batch processing |
| Query Processing | 0.8s per query | FAISS indexing |
| Response Generation | 3.2s per query | Context window optimization |

System specs for benchmarks: M1 Pro MacBook Pro with 16GB RAM.

## Development Challenges and Solutions

Building SentinelDocs presented several interesting challenges:

### Challenge 1: Document Format Handling

Different document formats require specialized handling. For PDFs with complex layouts, text extraction often produces fragmented content.

**Solution**: I implemented a multi-stage processing pipeline with format-specific extractors and post-processing to normalize text.

### Challenge 2: Context Window Limitations

Local LLMs have limited context windows (typically 4K-8K tokens), making it difficult to process large documents.

**Solution**: I developed a chunking strategy that balances chunk size with semantic coherence, combined with a retrieval-augmented generation approach.

### Challenge 3: Embedding Quality

The quality of document embeddings significantly impacts search relevance.

**Solution**: I experimented with various embedding models and selected one optimized for document similarity, with additional filtering techniques to improve retrieval precision.

## Use Cases and Applications

SentinelDocs is designed for a wide range of document analysis needs:

- **Legal Contract Analysis**: Extract key clauses, obligations, and deadlines
- **Research Paper Review**: Summarize findings and extract methodologies
- **Financial Report Analysis**: Identify trends, risks, and key metrics
- **Medical Record Review**: Extract patient history and treatment information
- **Technical Documentation**: Create searchable knowledge bases from technical docs

## Future Development Roadmap

While SentinelDocs is already fully functional, I have several enhancements planned:

1. **Expanded Language Support**: Add support for non-English documents
2. **Custom Embedding Models**: Allow users to select specialized embedding models
3. **Docker Containerization**: Simplify deployment across different environments
4. **Enhanced Visualization**: Add more advanced data visualization options
5. **Document Annotation**: Enable collaborative annotation and commenting

## Try It Yourself

SentinelDocs is an open-source project available on GitHub. If you work with sensitive documents and need AI-powered analysis without compromising privacy, you can get started with these simple steps:

1. Clone the repository: `git clone https://github.com/MayurHulke/SentinelDocs.git`
2. Install dependencies: `pip install -r requirements.txt`
3. Install and start Ollama with your preferred LLM
4. Launch the application: `streamlit run app.py`

For complete installation instructions and documentation, visit the [GitHub repository](https://github.com/MayurHulke/SentinelDocs).

## Conclusion

SentinelDocs demonstrates that powerful AI document analysis doesn't have to come at the expense of privacy. By leveraging local LLMs and efficient vector search, we can create tools that respect data sovereignty while still providing advanced analysis capabilities.

As local AI models continue to improve, I believe this privacy-first approach will become increasingly important for professionals working with sensitive information. SentinelDocs is my contribution to making AI more accessible and privacy-respecting for everyone.

I'd love to hear your thoughts or questions about SentinelDocs in the comments below!

## References

1. [Ollama - Run LLMs locally](https://ollama.ai/)
2. [LangChain - Framework for LLM applications](https://python.langchain.com/)
3. [FAISS - Facebook AI Similarity Search](https://github.com/facebookresearch/faiss)
4. [Streamlit - Framework for data apps](https://streamlit.io/)
5. [Sentence Transformers - Text embeddings](https://www.sbert.net/)
6. [spaCy - Industrial-strength NLP](https://spacy.io/)
7. [PyPDF2 - PDF Processing Library](https://pypdf2.readthedocs.io/)
8. [python-docx - DOCX Processing](https://python-docx.readthedocs.io/) 