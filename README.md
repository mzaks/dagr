
<p align="center">
  <img src="logo.png" alt="Dagr Logo" width="256"/>
</p>

Dagr is a high-performance, type-safe binary serialization framework for Swift. It uses a schema-first, code-generation approach to automatically create all the boilerplate code needed to build, read, and manage complex data graphs. This provides the raw performance of a custom binary format with the safety and developer-friendly ergonomics of a native Swift framework.

## Why Dagr?

Swift's standard `Codable` protocol is fantastic for working with formats like JSON, but it can be too slow or produce verbose output for performance-critical applications. On the other end, frameworks like Protocol Buffers or FlatBuffers offer high performance but can feel foreign in a Swift project, often requiring external tools and lacking support for complex object graphs.

Dagr was built to fill this gap, offering a "best of both worlds" solution with the following key advantages:

### High Performance
*   **Compact Binary Format:** Serialized data is significantly smaller than its JSON or XML equivalent, saving disk space and network bandwidth.
*   **Fast Serialization:** Bypasses the overhead of text-based parsing for maximum speed.
*   **Memory Optimization:** The DSL allows for fine-grained performance tuning via `frozen` and `sparse` attributes on nodes.

### Type Safety & Developer Experience
*   **Zero Boilerplate:** The code generator writes all the serialization logic for you, eliminating manual, error-prone work.
*   **Compile-Time Safety:** Define your schema in Swift and get full autocompletion and compile-time checks. Typos and type mismatches are caught by the compiler, not at runtime.
*   **Seamless Integration:** A native Swift Package Manager plugin automates code generation as part of your normal build process.

### Advanced Data Modeling
*   **Full Graph Support:** Dagr is explicitly designed to handle complex object graphs, including **cyclical references**, which cause many other frameworks to fail.
*   **Rich Type System:** Provides first-class support for not just structs (`Node`), but also **enums (`Enum`)** and **tagged unions (`UnionType`)**, including arrays of unions.

### Robust Schema Evolution
*   **Automated Compatibility Validation:** Dagr automatically saves a fingerprint of your schema and, on subsequent builds, validates that any changes are backward-compatible. This prevents you from accidentally shipping a breaking change.
*   **Forward & Backward Compatibility:** The framework is designed to allow new code to read old data and old code to safely ignore fields from new data.

### Ideal Applications for Dagr

Dagr is particularly well-suited for applications where the performance, type safety, and efficient handling of complex data models are paramount, and where standard serialization solutions (like JSON/`Codable`) might fall short.

*   **Games:** Saving and loading game state, managing complex in-game entities (characters, inventory, world objects) and their relationships, or bundling game assets.
*   **Mobile Applications with Rich Offline Data:** Apps that cache large amounts of structured data locally (e.g., content management apps, productivity tools, health trackers, e-commerce catalogs).
*   **High-Performance Server-Side Swift Applications:** Building APIs, microservices, or backend systems in Swift that require high throughput and low latency for data exchange between services or with clients.
*   **Embedded Systems and IoT Devices (if using Swift):** Data logging, configuration storage, or inter-device communication on resource-constrained hardware.
*   **Applications with Complex, Interconnected Data Models:** Any application where data naturally forms a graph (e.g., social networks, knowledge bases, document structures with cross-references, CAD/design software data).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
